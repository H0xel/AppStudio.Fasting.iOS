

# Стеки статей
На бэкенде данный список представлен списком папок каждая папка является набором статей, 
имя папки может быть произвольно, по имени папки будет производиться сортировка стеков в окне Explore

внутри папки стека находится файл info.json и папки со статьями
- info.json - файл содержит настройки информации об текущем стеке статей, ниже представлен формат
* - обязательное поле

{
    "title": "Заголовок списка статей",         // *, заголовок
    "size": "small",                            // *, значения small или large
    "novaTricks": {                             // - блок Новы, необязательный параметр
        "title": "More Tricks from Nova",       // * заголовок блока Nova
        "questions": [                          // * вопросы для новы
            "question1",
            "question2",
            "question3"
        ]
    }
}

- каждая папка со статьями содержит одну статью, внутри папки должны находиться следующий файлы
    - article.png
    - article.json
    - article.markdown

- article.png - изображение для статьи
- article.json - настройки статьи, файл имеет следующий формат
{
    "title": "Article title",                   // *, заголовок статьи
    "type": "article",                          // *, тип статьи "article" или "recipe"
    "free": true,                               // *, бесплатна ли статья или по подписке
    "cookTime": 24,                             // время приготовления
    "readTime": 24,                             // время чтения
    "nutritionProfile" {                        // калорийность блюда
        "calories": 12,
        "proteins": 12,
        "fats": 12,
        "carbs": 12
    }
}

- article.markdown - текстовый файл, содержит саму статью в формате markdown

