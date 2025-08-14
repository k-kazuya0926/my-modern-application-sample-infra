output "cluster_id" {
  description = "ECSクラスターのID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ECSクラスターのARN"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "ECSクラスター名"
  value       = aws_ecs_cluster.main.name
}