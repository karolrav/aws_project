resource "aws_amplify_app" "example" {
  name       = "example"
  repository = "https://github.com/karolrav/React-front"


  access_token = var.github_token

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 1
    frontend:
        phases:
            preBuild:
                commands:
                    - npm i
            build:
                commands:
                    - npm run build
        artifacts:
            baseDirectory: build
            files:
                - '**/*'
        cache:
            paths:
                - node_modules/**/*
  EOT
}

resource "aws_amplify_branch" "dev" {
  app_id      = aws_amplify_app.example.id
  branch_name= "master"
  stage = "DEVELOPMENT"
  enable_auto_build = true
}