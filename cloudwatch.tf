# Here you will see full implementation in Terraform of Cloudwatch alarms and email notifications. I focused my alarms on the following metrics:

# apiserver_storage_size_bytes
# apiserver_storage_objects
# apiserver_request_duration_seconds
# rest_client_request_duration_seconds
# etcd_request_duration_seconds

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_storage_size_bytes" {
  alarm_name = "eks-${local.cluster_name}-apiserver-storage-size-bytes"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "6000000000" # 6Gb (max is 8Gb)

  alarm_description = "Detecting high ETCD storage usage when 75%+ is being used in ${local.cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Maximum"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_storage_size_bytes"

  dimensions = {
    ClusterName = local.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_storage_objects" {
  alarm_name = "eks-${local.cluster_name}-apiserver-storage-objects"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "100000"

  alarm_description = "Detecting 100k+ ETCD storage objects in ${local.cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Maximum"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_storage_objects"

  dimensions = {
    ClusterName = local.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_request_duration_seconds" {
  alarm_name = "eks-${local.cluster_name}-apiserver-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "API server request duration exceeds 1 second in ${local.cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_request_duration_seconds"

  dimensions = {
    ClusterName = local.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_rest_client_request_duration_seconds" {
  alarm_name = "eks-${local.cluster_name}-rest-client-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "REST client request duration exceeds 1 second in ${local.cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "rest_client_request_duration_seconds"

  dimensions = {
    ClusterName = local.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_etcd_request_duration_seconds" {
  alarm_name = "eks-${local.cluster_name}-etcd-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "ETCD request duration exceeds 1 second in ${local.cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "etcd_request_duration_seconds"

  dimensions = {
    ClusterName = local.cluster_name
  }
}

resource "aws_sns_topic" "eks_alerts" {
  name = "eks-${local.cluster_name}-alerts"
}

resource "aws_sns_topic_subscription" "email_eks_alerts" {
  topic_arn = aws_sns_topic.eks_alerts.arn
  protocol  = "email"
  endpoint  = "eks_alerts@gmail.com"
}