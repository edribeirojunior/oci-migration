import oci
import os
import os.path
import sys
import re
import time

config = oci.config.from_file(profile_name="US")
compute_client = oci.core.ComputeClient(config)
work_requests = oci.work_requests.WorkRequestClient(config)

def export_image(image_id, details):
    export = compute_client.export_image(image_id, details)
    
    return export.data
    
def list_images_id(compartment_id, name):
    listing = compute_client.list_images(compartment_id, display_name=name)
    return listing.data[0].id

def list_work_request(compartment_id):
    work_request = work_requests.list_work_requests(compartment_id)
    return work_request.data

def details_work_request(work_request_id):
    iterate_details = []
    for x in work_request_id:
        details_work_request = work_requests.get_work_request(x)
        iterate_details.append(details_work_request.data)

    return iterate_details
    
if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise RuntimeError('Invalid Arguments.')

    compartment_id = sys.argv[1]
    image_name = list(sys.argv[2].split(','))
    bucket_name = "custom-images-ashburn"

    try:
        images_names = []
        print('Starting!') 
        for i in image_name:      
            create_details_kwargs = {
                    "destination_type": "objectStorageTuple",
                    "bucket_name": bucket_name,
                    "object_name": i,
                    "namespace_name":"skybrasil"
            }

            print("Image Listing...")
            image_value = list_images_id(compartment_id, i)
            imagedetail = oci.core.models.ExportImageViaObjectStorageTupleDetails(**create_details_kwargs)
            print("Export of Image %s Initialize..." % i)
            export_image(image_value, imagedetail)
            images_names.append(image_value)
        
        print("Monitoring Start...")
        monitoring = True
        details = list_work_request(compartment_id)
        objeto = [i.id for i in details]    
        while monitoring == True or len(objeto) > 0:
            iterate_details = details_work_request(objeto)
            id_work_request = []
            for z in iterate_details:
                if z.status == "IN_PROGRESS" and z.operation_type == "ExportImage":
                    id_work_request.append(z.id)
                    time.sleep(600)
                    print("#######################################################")
                    print("Work Request Image OCID: %s" % z.id)
                    print("Work Request Image Export: %d%%" % z.percent_complete)
                    print("#######################################################")
                    monitoring = True
                else: 
                    if z.percent_complete == 100.0:
                        objeto.remove(z.id)
                        if z.id in id_work_request:
                            id_work_request.remove(z.id)
                            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            print("Work Request with ID %s has Finished." % z.id)
                            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            print(len(id_work_request))
                            if len(id_work_request) == 0:
                                monitoring = False
                                print('Work Request Done!')
                    else:
                        objeto.remove(z.id)
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        print("Removing Failed Jobs")
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    

    except Exception as e:
        print("Exception Details: %s" % e)
