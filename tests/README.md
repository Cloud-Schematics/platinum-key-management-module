# tfxjs Tests

## Prerequisites

- NodeJS v18 or higher
- NPM v8 or higher

## Installation

Use the following commands to setup your development environment:

### Installing Command Line Tools

```shell
npm install -g tfxjs mocha
```

### Installing Node Packages

```shell
npm i 
```

## Running the Tests

### Setting Up Your Environment

Create a file `example_module/terraform.tfvars` for setting up your environment:
```terraform
ibmcloud_api_key="<your ibmcloud api key>"
```

### Running the Scripts

From this directory, use this command to run needed tests.

```shell
tfx .
```