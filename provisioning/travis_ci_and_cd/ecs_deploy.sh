#! /bin/bash
# Deploy only if it's not a pull request
if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  # Deploy only if this is a 'deployable' branch
  if [ "$TRAVIS_BRANCH" == "development" ] || [ "$TRAVIS_BRANCH" == "qa" ] || [ "$TRAVIS_BRANCH" == "production" ]; then

    case "$TRAVIS_BRANCH" in
      production)
        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_PRODUCTION
        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PRODUCTION
        ;;
      qa)
        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_PRODUCTION
        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PRODUCTION
        ;;
      *)
        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_DEVELOPMENT
        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_DEVELOPMENT
        ;;
    esac

    WEB_APP_SERVICE_NAME="scsbuster-web-application-$TRAVIS_BRANCH"
    CLUSTER_NAME="scsbuster-$TRAVIS_BRANCH"

    echo "Deploying $TRAVIS_BRANCH"
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws ecs update-service --cluster $CLUSTER_NAME --region us-east-1 --service $WEB_APP_SERVICE_NAME --force-new-deployment
  else
    echo "Skipping deploy because it's not a deployable branch"
  fi
else
  echo "Skipping deploy because it's a PR"
fi
