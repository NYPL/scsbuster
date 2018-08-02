# SCSBuster
An admin interface for ReCap/SCSB written in ruby on rails. Based on [NYPL/nypl-recap-admin](https://github.com/NYPL/nypl-recap-admin).

| Branch        | Status                                                                                                               |
|:--------------|:---------------------------------------------------------------------------------------------------------------------|
| `master`      | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=master)](https://travis-ci.org/NYPL/scsbuster)      |
| `development` | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=development)](https://travis-ci.org/NYPL/scsbuster) |
| `production`  | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=production)](https://travis-ci.org/NYPL/scsbuster)  |

## Running Locally

TODO: Setup and environment configuration, plus instructions on how to run locally.

## Git Workflow & Deployment

Our branches (in order of stability are):

| Branch      | Environment | AWS Account     |
|:------------|:------------|:----------------|
| master      | none        | none            |
| development | development | aws-sandbox     |
| production  | production  | aws-digital-dev |

### Cutting A Feature Branch

1. Feature branches are cut from `master`.
2. Once the feature branch is ready to be merged, file a pull request of the branch _into_ master.

### Deploying

TODO: [KK] Travis is not setup yet for this project. I hope to set it up in the near future. Temp instructions, but... I plan to make the following real.

We [theoretically will] use Travis for continuous deployment.
Merging to certain branches automatically deploys to the environment associated to
that branch.

Merging `master` => `development` automatically deploys to the development environment. (after tests pass).  
Merging `development` => `production` automatically deploys to the production environment. (after tests pass).

For insight into how CD works look at [.travis.yml](./.travis.yml) and the
[continuous_deployment](./continuous_deployment) directory.
The approach is inspired by [this blog post](https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/) ([google cached version](https://webcache.googleusercontent.com/search?q=cache:NodZ-GZnk6YJ:https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/+&cd=1&hl=en&ct=clnk&gl=us&client=firefox-b-1-ab)).
