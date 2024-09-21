# SCSBuster
An admin interface for ReCap/SCSB written in ruby on rails. Based on [NYPL/nypl-recap-admin](https://github.com/NYPL/nypl-recap-admin).

## Installing & Running Locally

This application uses [docker-compose.yml](./docker-compose.yml).
**You can edit code as on your machine and expect it to hot-reload like you usually would.
Forget Docker is there.**

### Setup

1. Clone this repo.
1. In this app's root directory `cp ./.env.example ./.env` and fill it out. (See directions in `.env.example`)
1. Add the following to `/etc/hosts`: `127.0.0.1 local.nypl.org`. This makes an alias as a public URL for our local IP. NYPL’s SSO service only accepts public URLs as the redirect URI. So for running locally, we need to assign a public address to our local IP.
1. Add your email address to s3://scsbuster-authorized-users-qa/authorization.json (nypl-digital-dev)

### Running

1. `docker-compose up`
1. Go to http://local.nypl.org:3001

### Testing

1.  `docker-compose run webapp bash` (brings up a web container)
1.  `RAILS_ENV=test bundle exec rspec` (in container)
1.  `exit` to leave the container.

### Rails Console

1.  `docker-compose run webapp bash` (brings up a web container)
1.  `bundle exec rails c` (in container)
1.  `exit` to leave the container.

### Debugging With Pry Remote

1.  `docker-compose run webapp bash` (brings up a web container)
1.  In the code, add your breakpoint with `binding.pry_remote`. Hit the endpoint.
1.  `bundle exec pry-remote` (in container)
1.  `exit` to leave the container.

## Git Workflow & Deployment

Our branches (in order of stability are):

| Branch      | Environment | AWS Account      |
|:------------|:------------|:-----------------|
| qa          | qa          | nypl-digital-dev |
| production  | production  | nypl-digital-dev |

### Cutting A Feature Branch

1. Feature branches are cut from `qa`.
2. Once the feature branch is ready to be merged, open a pull request of the branch _into_ qa.

### Deploying

Merging `feature_branch` => `qa` automatically deploys to the qa environment.
Merging `qa` => `production` automatically deploys to the production environment.
After a release, please backmerge production to qa with a PR.
