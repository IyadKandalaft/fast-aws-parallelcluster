# fast-aws-parallelcluster

A simple tool to automate the provisioning of an HPC cluster in AWS using the AWS ParallelCluster utility and execute a job on it.


## Getting Started

These instructions will allow you to quickly get started on your local machine or an AWS VM.

### Prerequisites

You will need the following 

```
Linux or Mac OS
Bash 4
GIT
```

### Setup

Create an access id and access secret key in the AWS Console

Create an AWS key pair in the AWS Console or via the CLI and download the private key

Set the path to the private key 

```
export AWS_SSH_KEY=~/.sshkey.pem
```

Ensure that the private key has mode 600

```
chmod 600 $AWS_SSH_KEY
```

Clone this repository

```
git clone https://github.com/IyadKandalaft/fast-aws-parallelcluster
cd fast-aws-parallelcluster
```

### Create the Cluster

Change into the directory and execute start_cluster.sh

```
./create_cluster.sh
```

### Deleting the Cluster

```
./delete_cluster.sh
```

## Modifying Cluster Configuration

To modify the cluster configuration, you will need to edit the pcluster.conf file.

Reference the [AWS Parallel Cluster Documentation](https://aws-parallelcluster.readthedocs.io/en/latest/configuration.html) for options that you can use.

Once you've made your modifications, delete and create teh cluster again.
