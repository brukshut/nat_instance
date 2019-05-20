# AWS Autoscaling Nat Instance

Typically, an amazon VPC is comprised of at least one public subnet, and a private subnet. Whilte the hosts on the public subnet(s) use an internet gateway to communicate with the outside world, hosts located on the private subnet(s) must use a NAT gateway to communicate with the outside world. As an end user of Amazon Web Services, you generally have two options when it comes to providing NAT services. You can use AWS hosted NAT service, or manage your own ec2 NAT instance. Each approach has drawbacks and advantages.

## AWS Hosted NAT Gateway Service

Amazon Web Services provides a hosted NAT gateway service, which ensures that all hosts on a private subnet will route their outbound traffic through a highly available, hosted NAT service. This is a hosted service which is more expensive than running a single lightweight ec2 NAT instance. If cost is not a consideration, using the hosted NAT gateway service is an attactive (and honestly the preferred) option. However, for small sites and individual users may not be able to afford this hosted service and thus will need to run an ec2 NAT instance.

## Using NAT Instances

In the past, AWS users have had to build and maintain ec2 NAT instances on their public subnets, which proxy requests from private subnets to the outside world using simple `iptables` rules. AWS provides prebuilt ami images that are suitable for use as NAT instances. Running an ec2 NAT instance has its drawbacks, however. It does not provide the redundancy and availability of the hosted NAT service. If you lose the ec2 NAT instance for any reason, your private hosts will no longer be able to talk to the outside world, until the host can be brought back, typically by some sort of manual or managed process.

## Using An Autoscaling Group With An Elastic Network Interface

By defining an ec2 autoscaling group comprised of a single host, we can ensure that our NAT instance, while perhaps not providing complete high availability, at least provides self healing capabilities. By defining a floating Elastic Network Interface with static, unchanging public and private IP addresses, we can ensure that the ec2 NAT instance managed by the autoscaling group is always reachable, regardless of whether the ec2 instance gets replaced. We use a separate utility `eni_ctl.sh` to locate and attach the ENI.

## Packer Definition

Inside the `packer` directory are the build description and the associated scripts required to configure the ec2 instance. I am currently not using the AWS provided ami, but rather build my own from scratch using the latest debian ami.

## Invocation

```
module "nat_instance" {
  source          = "github.com/brukshut/nat_instance"
  // access_list allows ssh access to nat_instance from outside
  access_list     = ["22.33.44.55/32"]
  ami_id          = "${data.aws_ami.nat_instance.id}"
  key_name        = "brukshut"
  name            = "brukshut-nat"
  public_fqdn     = "bastion.brukshut.nyc"
  private_fqdn    = "bastion.brukint.nt"
  private_ip      = "10.0.1.10"
  public_zone_id  = "${data.terraform_remote_state.route53_public.gturn_zone_id}"
  private_zone_id = "${module.route53_private.zone_id}"
  private_key     = "/Users/brukshut/.ssh/id_rsa"
  region          = "us-east-1"
  instance_type   = "t2.micro"
  // typically I set aside one public subnet for static ips
  // the other public subnet assigns addresses normally via dhcp
  subnet_id       = "${module.public_subnet.subnet_ids[0]}"
  eni_subnet_id   = "${module.public_subnet.subnet_ids[1]}"
  user            = "brukshut"
  vpc_id          = "${module.vpc.vpc_id}"
  vpc_cidr        = "${module.vpc.cidr_block}"
}
```
## Exported Values

# TODO

`terratest` for `nat_instance`


