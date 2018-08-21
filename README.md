# SCSBuster
An admin interface for ReCap/SCSB written in ruby on rails. Based on [NYPL/nypl-recap-admin](https://github.com/NYPL/nypl-recap-admin).

| Branch        | Status                                                                                                               |
|:--------------|:---------------------------------------------------------------------------------------------------------------------|
| `master`      | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=master)](https://travis-ci.org/NYPL/scsbuster)      |
| `development` | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=development)](https://travis-ci.org/NYPL/scsbuster) |
| `qa`          | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=qa)](https://travis-ci.org/NYPL/scsbuster)          |
| `production`  | [![Build Status](https://travis-ci.org/NYPL/scsbuster.svg?branch=production)](https://travis-ci.org/NYPL/scsbuster)  |

## Installing & Running Locally

This application uses [docker-compose.yml](./docker-compose.yml).
**You can edit code as on your machine and expect it to hot-reload like you usually would.
Forget Docker is there.**

### Setup

1. Clone this repo.
1. In this app's root directory `cp ./.env.example ./.env` and fill it out. (See directions in `.env.example`)
1. Add the following to `/etc/hosts`: `127.0.0.1 local.nypl.org`. This makes an alias as a public URL for our local IP. NYPL’s SSO service only accepts public URLs as the redirect URI. So for running locally, we need to assign a public address to our local IP.

### Running

1. `docker-compose up`
1. Go to http://local.nypl.org:3001

### Testing

We rely on our CI service's build status, but it's important to be able to run
tests on your localhost. This is how to run tests (from inside the web app's container)

_With the stack running..._

1.  `docker-compose exec webapp bash` (brings you onto the running container)
1.  `su app`, `cd ~/scsbuster && bundle exec rspec` (in container)
1.  `exit` to leave bash.

### Rails Console

1.  `docker-compose exec webapp bash` (brings you onto the running container)
1.  `su app`, `cd ~/scsbuster && bundle exec rails c` (in container)
1.  `exit` to leave bash.

### Debugging With Pry Remote

1.  `docker-compose exec webapp bash` (brings you onto the running container)
1.  In code, add your breakpoint with `binding.pry_remote`, hit the endpoint
1.  `su app`, `cd ~/scsbuster && bundle exec pry-remote` (in container)
1.  `exit` to leave bash.

## Git Workflow & Deployment

Our branches (in order of stability are):

| Branch      | Environment | AWS Account     |
|:------------|:------------|:----------------|
| master      | none        | none            |
| development | development | aws-sandbox     |
| qa          | qa          | aws-digital-dev |
| production  | production  | aws-digital-dev |

### Cutting A Feature Branch

1. Feature branches are cut from `master`.
2. Once the feature branch is ready to be merged, file a pull request of the branch _into_ master.

### Deploying

Merging `master` => `development` automatically deploys to the development environment. (after tests pass).
Merging `development` => `qa` automatically deploys to the qa environment. (after tests pass).
Merging `qa` => `production` automatically deploys to the production environment. (after tests pass).

For insight into how CD works look at [.travis.yml](./.travis.yml) and the
[continuous_deployment](./continuous_deployment) directory.
The approach is inspired by [this blog post](https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/) ([google cached version](https://webcache.googleusercontent.com/search?q=cache:NodZ-GZnk6YJ:https://dev.mikamai.com/2016/05/17/continuous-delivery-with-travis-and-ecs/+&cd=1&hl=en&ct=clnk&gl=us&client=firefox-b-1-ab)).
