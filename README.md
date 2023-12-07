# terraform-modules

This repository should contain implementation of all modules used in:

* <https://github.com/austinobioma/oxcloud_terraform_infra>

## Pre-Commit Hooks

When developing on this repo there are set of `pre-commit` hooks that will help make development easier and ensure our standards are in place. Before every **commit** a `terraform fmt` and `tflint` are run. On every **push** `checkov` will be run to check for misconfigurations, `checkov` is a lot slower to run, so before you push you can also run `tf/checkov` to debug anything.

The development environment and build pipeline uses the `Dockerfile` at `jenkins/build.dockerfile`. This _should_ work on **Windows** , **OSX** and **Linux**. To run the pre-hooks from this container you can use:

```
make tf/ci
```

This emulates what will be run in CI. It will only operate against the changes files that are staged. If you want to check all files you can run:

```
make tf/ci-all
```

To run checks individually you can also run these commands:

```sh
make tf/docs      # generates docs for all modules based on variables, outputs, providers, etc.
make tf/fmt       # will format all files using terraform fmt
make tf/lint      # checks for dead code, naming standards, module layout, etc.
make tf/checkov   # checks for security vulnerabilities and misconfigurations against standard recommendations
make docker/build # this will rebuild the docker container
```

If you receive a failure because of terraform formatting lint failure you can run 

```
make tf/fmt
```

This will format all of your code, restage the code and attempt to commit again.

### Debugging Pre-Commit Hooks

When developing you will eventually _fail_ some of the linting checks. To debug linting, first understand
what stage passed by checking the output

```
Terraform fmt............................................................Passed
tflint...................................................................Passed
Checkov..................................................................Passed
Terraform docs (overwrite README.md).....................................Failed
```

In this case `Terraform docs` has `Failed`, this means there is a diff in the pre-commit checks. This means we need to generate some docs to get this aligned with the checks

```
git add <changes>
make tf/docs
```

## Developing

When working on these modules locally you can test the module with one of the `terraform-infra-*` repos by using these commands:

```
cd /path/to/terraform-infra-nonprod/dcim_nonprod/us-west-1/nonprod/common-network/vpc-apps
terragrunt validate-all --terragrunt-source /path/to/terraform-modules
```

## Major directories
 
### compute

Place for modules related to computing services: ec2 servers, load balancers, storage for computing services

### storage

Place for modules related to database services: rds, elsticsearch, redis

### network

Place for modules related to network services: vpc, transient gateway, dns, direct connect 

## Tagging

After a completion of sprint and demonstration of working solution on sandbox dev environment code should be tagged with version in format
X.Y.Z (following semantic versioning https://semver.org/)

## Branches

### dev 

Branch that should be used as a source on sandbox dev environment and lower non-prod environments (dev, qa)

### master 

Branch that should be used as a source on higher non-prod environments (uat, perf) and prod environment. Code should be promoted to master by using merge request from dev branch

### feature/ECM-XYZ_\<meaningful_description_here\>

Feature branches created for development/fixes of modules

### release/X.Y

To be considered if new need to introduce release branch (retro after two sprints)


## Commits

Commit message should contain jira identifier related to task you are working on. Allowed commit message pattern is
```
ECM\-\d+|Merge.*|Revert.*
```
Example
```
ECM-451 README.md update
```

## How to contribute
1. Create feature branch from dev branch
2. Develop your code on feature branch 
3. Test it in sandbox repository
4. Create merge request: feature branch -> dev branch
5. Ask team for code review and approvals
6. Merge code to dev

## Module structure

We are following terraform standard for module, every modules should include:
* vars.tf - input variables
* main.tf - module code
* output.tf - output variables
* examples - subdirectory with examples how to use modules
* README.md - simple documentation of module with short description of input/output variables


## Testing

Now: you can test if you module works by using it in https://github.com/grycare/cloud_terraform-infra-sandbox, in personal environment. Before merging your code to dev branch you can checkout your modules from feature branch:
```
github.com/grycare/cloud_terraform-modules//network/newmodule?ref=feature/ECM-XYZ_newmodule
```

## Wiki links
<!-- * https://wiki.corp.grycare.com/confluence/display/PE/Terraform+Repo+Design+-+Phase+2 -->
