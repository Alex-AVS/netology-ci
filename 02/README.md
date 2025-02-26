# Процессы CI/CD

## SonarQube

Создаём новый проект:

![tf](img/02-sonar-newprj.png)

![tf](img/02-sonar-newprj2-localproject.png)

Устанавливаем sonar-scanner:

![tf](img/02-sonar-scanner-ver.png)

Запускаем скан на тестовом файле:

![tf](img/02-sonar-newprj-1st-scan.png)

Обнаружили ошибки:

![tf](img/02-sonar-newprj-1st-scan-bugs.png)

Исправляем, сканируем снова:

![tf](img/02-sonar-newprj-2t-scan-clean.png)

## Nexus

Добавляем две версии тестового артифакта:

![tf](img/02-nexus-artif-loaded.png)

Файл [maven-metadata.xml](src/mvn/maven-metadata.xml)

## Maven

Устанавливаем Maven:

![tf](img/02-maven-version.png)

Изменяем файл [pom.xml](src/mvn/pom.xml), чтобы он использовал наш репозиторий и артефакт, и собираем:

![tf](img/02-maven-build.png)