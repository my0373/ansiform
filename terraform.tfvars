public_subnet_cidrs = "10.0.1.0/24"
private_subnet_cidrs = "10.0.2.0/24"
aws_region = "eu-west-1"

/*  
# TODO: Make this a data lookup. 
# For now it is hardcoded to eu-west-1 where I test. 
# Images can be found here 
# https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#AMICatalog:
*/

# The AMI Image to deploy
rhel_ami = "ami-01a6233315e045110"

# The ec2 key pair to deploy on the hosts
ec2_key_pair_name = "laptop"

# The AWS ec2 instance size
ec2_instance_type = "t3.micro"
