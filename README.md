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

### Running

1. `docker-compose up`
1. Go to http://localhost:3001

### Testing (if/when we bring in RSpec)

We rely on our CI service's build status, but it's important to be able to run
tests on your localhost. This is how to run tests (from inside the web app's container)

_With the stack running..._

1.  `docker-compose exec webapp bash` (brings you onto the running container)
1.  `su app`, `cd ~/scsbuster && bundle exec rspec` (in container)

### Rails Console

1.  `docker-compose exec webapp bash` (brings you onto the running container)
1.  `su app`, `cd ~/scsbuster && bundle exec rails c` (in container)

### Debugging With Pry

TODO: Fill this out

### Getting Credentials and Environment Variables
Please get all the necessary credentials and environment variables from NYPL before you run this application. You can find all the variables you need in `.env.example`. Once you get them, create a `.env` file in the root folder, copy the content from `.env.example` but fill in the real values respectively. See the next section to get more information about OAuth credentials.

### OAuth Configuration
The app is configured to use `isso.nypl.org` for OAuth authentication. You will need to pass in the correct `CLIENT_SECRET` as an environment variable for the authentication to work correctly. You can look up the secret in the parameter store; the clientID is `platform_admin`. Set the environment variable `CLIENT_SECRET` to the client secret when running the app, as set out below.

In order to use the SSO authentication your browser needs to talk to your app on an `nypl.org` address (as otherwise isso.nypl.org will not authenticate it — let's use `local.nypl.org` as an example) on port `80` (as isso.nypl.org will always redirect to port 80). To make `local.nypl.org` a local alias for your computer (on a Linux, Mac or other \*nix OS) you need to add the following line to your `/etc/hosts` file:

```
127.0.0.1 local.nypl.org
```

You only need to do that once (well, maybe again if you upgrade your OS — that _might_ update your `hosts` file).

Also the callback URI's port needs to be registered to `isso.nypl.org` before so we can use it. Now port `3001` has been registered.

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
