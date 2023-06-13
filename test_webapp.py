import os
import sys
import pytest
import subprocess
import requests
import boto3
import time
import logging



os.environ["AWS_DEFAULT_REGION"] = 'us-east-2'

@pytest.fixture(scope="session")
def project_path():
    return os.path.abspath(os.path.dirname(__file__))


@pytest.fixture(scope="session")
def terraform_dir():
    return "/Users/u1127499/Desktop/terraform_assignment"


@pytest.fixture(scope="session")
def load_balancer_name():
    #region_name = "us-east-2"
    elbv2 = boto3.client('elbv2')
    response = elbv2.describe_load_balancers(Names=['webpage-lb-1'])
    if 'LoadBalancers' in response and response['LoadBalancers']:
        return response['LoadBalancers'][0]['LoadBalancerName']
    else:
        raise ValueError("Load balancer not found.")
    #return sys.argv[2]


@pytest.fixture(scope="session")
def terraform_init(terraform_dir):
    subprocess.check_call(["terraform", "init"], cwd=terraform_dir)


def test_terraform_destroy(terraform_dir, terraform_init):
    result = subprocess.run(
        ["terraform", "destroy", "-auto-approve"], cwd=terraform_dir, capture_output=True, input="yes\n".encode()
    )
    assert result.returncode == 0, result.stderr.decode()

def test_terraform_plan(terraform_dir, terraform_init):
    result = subprocess.run(
        ["terraform", "plan", "-out=tfplan"], cwd=terraform_dir, capture_output=True
    )
    assert result.returncode == 0, result.stderr.decode()


def test_terraform_apply(terraform_dir, terraform_init):
    result = subprocess.run(
        ["terraform", "apply", "tfplan"], cwd=terraform_dir, capture_output=True, input="yes\n".encode()
    )
    assert result.returncode == 0, result.stderr.decode()

    # Wait for resources to be provisioned
    time.sleep(60)  # Wait for 60 seconds


def test_webpage_reachable(load_balancer_name):
    #os.environ["AWS_DEFAULT_REGION"] = "us-east-2a"
    #region_name = "us-east-2"
    client = boto3.client("elbv2")
    response = client.describe_load_balancers(Names=[load_balancer_name])
    load_balancer_dns = response["LoadBalancers"][0]["DNSName"]
    webpage_url = f"http://{load_balancer_dns}"
    response = requests.get(webpage_url)
    assert response.status_code == 200, "Webpage is not reachable."
    logging.info(f"Webpage at URL {webpage_url} is reachable.")



if __name__ == "__main__":
    pytest.main(["-v"])
