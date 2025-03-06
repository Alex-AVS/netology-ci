# Teamcity

## Устанавливаем TeamCity

![tf](img/04-tc-create-2-1st-start.png)

![tf](img/04-tc-create-3-startingt.png)

Добавляем агент:

![tf](img/04-tc-create-4-agentadded.png)

## Создаём проект и добавляем шаги сборки

Создаём сборку, которая будет собирать наш тестовый проект из репозитория [https://github.com/Alex-AVS/example-teamcity.git](https://github.com/Alex-AVS/example-teamcity.git)

![tf](img/04-tc-prj-1-createbuildcfg.png)

![tf](img/04-tc-prj-1-createbuildcfg-2.png)

Запускаем первую сборку:

![tf](img/04-tc-prj-2-building.png)

![tf](img/04-tc-prj-3-build-done.png)

Добавляем условия сборки для deploy и test, Меняем pom.xml и settings.xml

![tf](img/04-tc-prj-4-master-branch-condition-2steps.png)

Собираем снова:

![tf](img/04-tc-prj-5-master-build-done.png)

Собранный артефакт в Nexus:

![tf](img/04-tc-prj-5-master-build-nexus.png)

_Пункт "8. Мигрируйте build configuration в репозиторий." - **не понятен**._ Единственное, что _относительно_ подходит под определение - 
это пункт `Administration - Configs repository` глобальных настроек ТС. 
Но, этого **нельзя делать** в публичный репозиторий, о чём прямо написано на странице настроек:

![tf](img/04-tc-prj-6-config-sync2.png)

При этом в репозиторий синхронизируется всё, включая загруженные ключи и пароли! Github автоматически блокирует найденный ключ.

Конфигурация, сохранённая в ветке репозитория:

![tf](img/04-tc-prj-6-config-sync-github.png)

Создаём новую ветку в тестовом репозитории, добавляем новый метод `sayHungry` в класс

```
public String sayHungry(){
		return "As hungry as a hunter!";
	}
```

и соответствующий метод в тест:

```
@Test
	public void welcomerSaysHungry(){
		assertThat(welcomer.sayHungry(), containsString("hunter"));
	}

```
Коммитим, проверяем, что сборка test запустилась:

![tf](img/04-tc-prj-7-newbranch-buid.png)

Тесты пройдены

![tf](img/04-tc-prj-7-newbranch-buid-done.png)

Настраиваем путь до артефактов:

![tf](img/04-tc-prj-8-master-artifacts-setting.png)

Собираем master. Артефакты появились в результатах:

![tf](img/04-tc-prj-8-master-artifacts.png)

