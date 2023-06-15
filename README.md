# Web Page on AWS with Terraform

The project scope is to build a simple webpage deployed using Terraform on AWS

# Installation

The project use external libraries and services to function:
1. **Terraform** 
  It's an open-source infrastructure-as-code software tool used to deploy and provision via programming on AWS
  
  Install Terraform plugin from File -> Settings -> Plugins. Search for terraform/hashicorp and install the plugin.
  
  <img width="966" alt="image" src="https://github.com/mariomasperi/terraform_assignment/assets/10673190/c0b5f89a-937d-45ed-9c97-5071b41e0f02">

2. **Pytest**
  It's an open source tool to test any application using python
  Go to the terminal in your IDE and execute the following command: *pip install pytest* 

3. **Boto3**
  It provides a python API for AWS infrastructure services
  Go to the terminal in your IDE and execute the following command: *pip install boto3* 
  
# How to Use?

1. It's important that you have a user created and the Key-pair saved locally on your machine and swith the name **EC2-key-pair**.
   The infrastructure used *us-east-2* as region in AWS, please make sure is available.

2. The main.tf contains all terraform code needed to create and provision the necessary infrastructure on AWS.
   If you want to deploy and run it on AWS you just need, after the installation above, to pull the file in your IDE and then execute the following command:

    *terraform init*
    *terraform plan*
    *terraform apply*
    
3. After deploy the infrastructure, you can check if the webpage is reachable, copying the DNS address of one of the application load balancer.    

<img width="1457" alt="image" src="https://github.com/mariomasperi/terraform_assignment/assets/10673190/24db7096-829b-4754-a935-2a61a8dde620">

4. Paste the address on your web browser and you should be able to display the following page:

<img width="857" alt="image" src="https://github.com/mariomasperi/terraform_assignment/assets/10673190/8ef16c9f-c2a7-4bec-be1d-8ec7a35f80b3">

# How to test?

1. You can alternatively test the application running a Pytest script instead, the code will create the infrastructure and provide you a assert status
  To do that you need to pull the file **test_webapp.py** in your IDE and perform  the following changes to the code:
  - Insert your project path in the following function:

<img width="548" alt="image" src="https://github.com/mariomasperi/terraform_assignment/assets/10673190/179c3f85-a160-41a7-b167-f0bce1f61712">

2. Run the following command in the IDE terminal:
  *python -m pytest test_webapp.py* 
  
  It will take sometime to create the infrastructure, after that the test should be seen as passed.




  
   
