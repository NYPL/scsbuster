data "aws_sns_topic" "rc_alarms" {
  name = "research-catalog-team-alarms-production"
}

resource "aws_cloudwatch_log_metric_filter" "log_error" {
  name           = "SCSBusterLogError"
  pattern        = "{ $.level = \"FATAL\" }"
  log_group_name = "/ecs/scsbuster-production-tf"

  metric_transformation {
    name      = "SCSBusterLogError"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "log_error_alarm" {
  alarm_name = "SCSBusterLogErrorAlarm"

  alarm_description = "Triggered when there's 1 or more fatal error log to SCSBuster within 5 minutes."

  namespace   = "LogMetrics"
  metric_name = "SCSBusterLogError"

  statistic = "Sum"

  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  datapoints_to_alarm = 1

  treat_missing_data = "notBreaching"

  alarm_actions = [data.aws_sns_topic.rc_alarms.arn]
}
