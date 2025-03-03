# Jenkins

## Устанавливаем Jenkins
Используем 2 ВМ AlmaLinux 9.

![tf](img/03-jenkins-start.png)

![tf](img/03-jenkins-inited.png)

Добавляем рабочую ноду:

![tf](img/03-jenkins-node-added.png)

## Freestyle Job
Создадим задачу:
Здесь и далее используем репозиторий с ролью для установки Vector: [https://github.com/Alex-AVS/vector-role.git](https://github.com/Alex-AVS/vector-role.git)

![tf](img/03-jenkins-freest-prj-repo.png)

![tf](img/03-jenkins-freest-prj-step.png)

Запустили:

![tf](img/03-jenkins-freest-prj-inprogr.png)

Успех:

![tf](img/03-jenkins-freest-prj-output.png)

## Declarative Pipeline

Создадим задачу:

![tf](img/03-jenkins-pipeline-prj-script.png)

Выполнилось:

![tf](img/03-jenkins-pipeline-prj-success.png)

Перенесли скрипт в файл:

![tf](img/03-jenkins-pipeline-prj-script-to-file.png)

Выполнилось со 2 раза, сначала забыл закомитить :

![tf](img/03-jenkins-pipeline-prj-script-to-file-success.png)


## Multibranch pipeline
Создаем задачу. Запустилось сканирование:

![tf](img/03-jenkins-multibranch-scanning.png)

Успешно.
 
![tf](img/03-jenkins-multibranch-found.png)

## Scripted pipeline

Клонируем [репозиторий](https://github.com/Alex-AVS/example-playbook), создаём задачу:

![tf](img/03-jenkins-scripted-configl.png)

Выполняем. Ошибка:

![tf](img/03-jenkins-scripted-fail.png)

Добавляем пользователя `jenkins` в sudoers и повторяем. Успех:

![tf](img/03-jenkins-scripted-success.png)

Изменяем скрипт, добавляем в задачу параметр.

![tf](img/03-jenkins-scripted-parameter.png)

Запускаем:

![tf](img/03-jenkins-scripted-parameter-not-set.png)

Запускаем с установленным флагом:

![tf](img/03-jenkins-scripted-parameter-set.png)

![tf](img/03-jenkins-scripted-parameter-set-result.png)

Итоговый скрипт: [ScriptedJenkinsfile](pipeline/ScriptedJenkinsfile)

