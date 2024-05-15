# Task 4
## Dockerfile для сборки образа task_4, который содержит следующие программы:
- bwa-mem2 v.2.2.1
- multiqc v.1.21
- samtools v.1.20
- picard v.3.1.1

### Сборка:
`docker build --no-cache -t task_4 <dockerfile_path>`

### Запуск:
`docker run -it task_4`

С монтированием тома:  
`-v <path_to_directory_on_host>:<path_inside_container>`
