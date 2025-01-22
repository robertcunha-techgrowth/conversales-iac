# Conversales Infrastructure as Code

## Description

This project exists to maintain the entire infrastructure from the project Conversales. This document must store all important rules and steps to implement the infrastructure right.

## Get Started

### Create a S3 Bucket

First of all, you must create a S3 Bucket to store the state of the terraform. Name it as you wish, just remember to change it on main.tf

### Create IAM Terraform

Now you must create the IAM terraform. You'll use credentials from this user to call all terraform commands.

The permissions are the following

- AmazonEventBridgeFullAccess
- AmazonS3FullAccess
- AWSLambda_FullAccess
- CloudWatchFullAccessV2
- IAMFullAccess
- AmazonEC2ContainerRegistryFullAccess

### Create Custom Domain Name for Serverless

Well, this should be on the serverless.yml, but due to a lot of problems in this configuration, we decided to do it manually.

To do it, log into the account where is the API Gateway. Go to the API Gateway and select the tab Custom domain names.

### Lambdas and Private Subnets

Lambdas need to access the internet. To do it, we create a NAT Instace.
