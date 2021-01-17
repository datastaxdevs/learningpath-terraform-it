# Hands-on Lab "Terraform it!"

Welcome to Infrastructure as Code first touch workshop! 

**DISCLAIMER** Usage of the cloud providers (in this workshop we use AWS) may lead to the costs. This workshop is free-tier eligible and shouldn't cost anything if you are a free tier user. If your free tier is expired already, running this workshop may cost you just a few cents, but don't fortget to delete the resources you will create. DataStax has no responsibility for any costs taken for the workshop.

## Materials

* [Workshop](https://youtu.be/d4bxNeVAduA)
* [Presentation](./slides.pdf)
* [Article draft](./article-draft.pdf)

## Practice

### Requirements

* AWS Account
* AWS Credentials configured [as explained](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

### Steps
* Clone the reposiroty
* Install [terraform](https://www.terraform.io/downloads.html)
* `terraform init`
* `terraform plan`
* `terraform apply` <-- infra created
* `terraform destroy`  <-- infra terminated

**IMPORTANT** Don't forget to remove infra otherwise there may be costs. 
