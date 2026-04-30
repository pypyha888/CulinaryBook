-- =============================================
-- 🏰 СОЗДАНИЕ БАЗЫ ДАННЫХ
-- =============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CulinaryBookDB')
BEGIN
    CREATE DATABASE [CulinaryBookDB]
END
GO

USE [CulinaryBookDB]
GO

-- =============================================
-- 🗑️ УДАЛЕНИЕ ТАБЛИЦ (если уже есть)
-- =============================================
IF OBJECT_ID('dbo.CookingSteps', 'U') IS NOT NULL DROP TABLE [dbo].[CookingSteps]
IF OBJECT_ID('dbo.RecipeIngredients', 'U') IS NOT NULL DROP TABLE [dbo].[RecipeIngredients]
IF OBJECT_ID('dbo.RecipeTags', 'U') IS NOT NULL DROP TABLE [dbo].[RecipeTags]
IF OBJECT_ID('dbo.RecipeImages', 'U') IS NOT NULL DROP TABLE [dbo].[RecipeImages]
IF OBJECT_ID('dbo.LikeRecipes', 'U') IS NOT NULL DROP TABLE [dbo].[LikeRecipes]
IF OBJECT_ID('dbo.Reviews', 'U') IS NOT NULL DROP TABLE [dbo].[Reviews]
IF OBJECT_ID('dbo.Recipes', 'U') IS NOT NULL DROP TABLE [dbo].[Recipes]
IF OBJECT_ID('dbo.Ingredients', 'U') IS NOT NULL DROP TABLE [dbo].[Ingredients]
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE [dbo].[Categories]
IF OBJECT_ID('dbo.Authors', 'U') IS NOT NULL DROP TABLE [dbo].[Authors]
IF OBJECT_ID('dbo.Tags', 'U') IS NOT NULL DROP TABLE [dbo].[Tags]
GO

-- =============================================
-- 🏗️ СОЗДАНИЕ ТАБЛИЦ
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Authors](
    [AuthorID] [int] NOT NULL,
    [AuthorName] [nvarchar](100) NOT NULL,
    [Login] [nvarchar](100) NOT NULL,
    [Password] [nvarchar](50) NOT NULL,
    [BirthDay] [date] NULL,
    [Number] [nvarchar](50) NULL,
    [Stage] [float] NULL,
    [Mail] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED ([AuthorID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Categories](
    [CategoryID] [int] NOT NULL,
    [CategoryName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED ([CategoryID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Tags](
    [TagID] [int] NOT NULL,
    [TagName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED ([TagID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ingredients](
    [IngredientID] [int] NOT NULL,
    [IngredientName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED ([IngredientID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Recipes](
    [RecipeID] [int] NOT NULL,
    [RecipeName] [nvarchar](200) NOT NULL,
    [Description] [nvarchar](max) NULL,
    [CategoryID] [int] NULL,
    [AuthorID] [int] NULL,
    [CookingTime] [int] NULL,
    [Image] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED ([RecipeID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[CookingSteps](
    [StepID] [int] NOT NULL,
    [RecipeID] [int] NULL,
    [StepNumber] [int] NULL,
    [StepDescription] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([StepID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[RecipeImages](
    [ImageID] [int] NOT NULL,
    [RecipeID] [int] NULL,
    [ImagePath] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED ([ImageID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[RecipeIngredients](
    [RecipeIngredientID] [int] NOT NULL,
    [RecipeID] [int] NULL,
    [IngredientID] [int] NULL,
    [Quantity] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED ([RecipeIngredientID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[RecipeTags](
    [RecipeTagID] [int] NOT NULL,
    [RecipeID] [int] NULL,
    [TagID] [int] NULL,
PRIMARY KEY CLUSTERED ([RecipeTagID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LikeRecipes](
    [id] [int] NOT NULL,
    [idAuthor] [int] NOT NULL,
    [idRecipes] [int] NOT NULL,
PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Reviews](
    [ReviewID] [int] NOT NULL,
    [RecipeID] [int] NULL,
    [ReviewText] [nvarchar](max) NULL,
    [Rating] [int] NULL,
PRIMARY KEY CLUSTERED ([ReviewID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- =============================================
-- 🔗 ВНЕШНИЕ КЛЮЧИ
-- =============================================
ALTER TABLE [dbo].[CookingSteps] WITH CHECK ADD CONSTRAINT [FK_CookingSteps_Recipes] FOREIGN KEY([RecipeID]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO
ALTER TABLE [dbo].[LikeRecipes] WITH CHECK ADD CONSTRAINT [FK_LikeRecipes_Authors] FOREIGN KEY([idAuthor]) REFERENCES [dbo].[Authors] ([AuthorID])
GO
ALTER TABLE [dbo].[LikeRecipes] WITH CHECK ADD CONSTRAINT [FK_LikeRecipes_Recipes] FOREIGN KEY([idRecipes]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO
ALTER TABLE [dbo].[RecipeImages] WITH CHECK ADD CONSTRAINT [FK_RecipeImages_Recipes] FOREIGN KEY([RecipeID]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO
ALTER TABLE [dbo].[RecipeIngredients] WITH CHECK ADD CONSTRAINT [FK_RecipeIngredients_Ingredients] FOREIGN KEY([IngredientID]) REFERENCES [dbo].[Ingredients] ([IngredientID])
GO
ALTER TABLE [dbo].[RecipeIngredients] WITH CHECK ADD CONSTRAINT [FK_RecipeIngredients_Recipes] FOREIGN KEY([RecipeID]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO
ALTER TABLE [dbo].[Recipes] WITH CHECK ADD CONSTRAINT [FK_Recipes_Authors] FOREIGN KEY([AuthorID]) REFERENCES [dbo].[Authors] ([AuthorID])
GO
ALTER TABLE [dbo].[Recipes] WITH CHECK ADD CONSTRAINT [FK_Recipes_Categories] FOREIGN KEY([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[RecipeTags] WITH CHECK ADD CONSTRAINT [FK_RecipeTags_Recipes] FOREIGN KEY([RecipeID]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO
ALTER TABLE [dbo].[RecipeTags] WITH CHECK ADD CONSTRAINT [FK_RecipeTags_Tags] FOREIGN KEY([TagID]) REFERENCES [dbo].[Tags] ([TagID])
GO
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Recipes] FOREIGN KEY([RecipeID]) REFERENCES [dbo].[Recipes] ([RecipeID])
GO

-- =============================================
-- 🏷️ ТЕГИ
-- =============================================
INSERT INTO [dbo].[Tags] ([TagID], [TagName]) VALUES
(1, N'Завтрак'),
(2, N'Обед'),
(3, N'Ужин'),
(4, N'Десерт'),
(5, N'Суп'),
(6, N'Выпечка'),
(7, N'Напиток'),
(8, N'Быстрый'),
(9, N'Праздничный'),
(10, N'Вегетарианский')
GO

-- =============================================
-- 📁 КАТЕГОРИИ
-- =============================================
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName]) VALUES
(1, N'Первые блюда'),
(2, N'Вторые блюда'),
(3, N'Выпечка и десерты'),
(4, N'Напитки'),
(5, N'Закуски'),
(6, N'Салаты')
GO

-- =============================================
-- 🧙 АВТОРЫ
-- =============================================
INSERT INTO [dbo].[Authors] ([AuthorID], [AuthorName], [Login], [Password], [BirthDay], [Number], [Stage], [Mail]) VALUES
(1, N'Гарри Поттер',       N'harry',      N'expelliarmus', '1980-07-31', N'+7 (999) 111-22-33', 7,   N'harry@hogwarts.edu'),
(2, N'Гермиона Грейнджер', N'hermione',   N'alohomora',    '1979-09-19', N'+7 (999) 222-33-44', 7,   N'hermione@hogwarts.edu'),
(3, N'Рон Уизли',          N'ron',        N'wingardium',   '1980-03-01', N'+7 (999) 333-44-55', 7,   N'ron@hogwarts.edu'),
(4, N'Альбус Дамблдор',    N'dumbledore', N'sherbet',      '1881-07-09', N'+7 (999) 000-00-01', 115, N'dumbledore@hogwarts.edu'),
(5, N'Северус Снейп',      N'snape',      N'sectumsempra', '1960-01-09', N'+7 (999) 000-00-02', 20,  N'snape@hogwarts.edu')
GO

-- =============================================
-- 🍽️ РЕЦЕПТЫ
-- =============================================
INSERT INTO [dbo].[Recipes] ([RecipeID], [RecipeName], [Description], [CategoryID], [AuthorID], [CookingTime], [Image]) VALUES
(1,  N'Тыквенный пирог Хогвартса',
     N'Классический тыквенный пирог, который подают на праздничных пирах в Большом Зале Хогвартса. Нежная начинка с корицей и мускатным орехом в хрустящем тесте.',
     3, 2, 90, N'pumpkin_pie.jpg'),
(2,  N'Кляксопуст жареный',
     N'Хрустящие жареные кляксопусты с чесночным маслом и зеленью — любимая закуска Рона Уизли на рождественском столе семьи.',
     5, 3, 25, N'sausages.jpg'),
(3,  N'Суп из котла Хагрида',
     N'Наваристый мясной суп с овощами по рецепту Рубеуса Хагрида. Варится в большом котле и хватает на весь Хогвартс.',
     1, 4, 120, N'soup.jpg'),
(4,  N'Сливочное пиво',
     N'Знаменитый тёплый напиток из трактира «Три метлы». Слегка пенистый, с карамельным послевкусием и ноткой ванили.',
     4, 1, 15, N'butterbeer.jpg'),
(5,  N'Шоколадные лягушки домашние',
     N'Домашние шоколадные лягушки — точная копия магазинных из Хогсмида. Внутри прячется сюрприз — карточка с волшебником.',
     3, 2, 45, N'choco_frog.jpg'),
(6,  N'Пастуший пирог Большого Зала',
     N'Сытный пирог из картофельного пюре с мясной начинкой. Подаётся каждую среду в Большом Зале Хогвартса с золотистой корочкой.',
     2, 5, 60, N'shepherd_pie.jpg'),
(7,  N'Имбирные печенья Уизли',
     N'Рождественские имбирные печенья по фирменному рецепту миссис Уизли. Хрустящие снаружи, мягкие внутри, с глазурью.',
     3, 3, 40, N'ginger_cookies.jpg'),
(8,  N'Зелье бодрости (кофе с пряностями)',
     N'Горячий напиток на основе крепкого кофе с добавлением корицы, кардамона и мёда. Профессор Снейп называет его «слабейшим зельем».',
     4, 5, 10, N'spiced_coffee.jpg'),
(9,  N'Ростбиф праздничного пира',
     N'Сочный ростбиф с травяной корочкой — центральное блюдо рождественского стола в Хогвартсе. Подаётся с соусом из красного вина.',
     2, 4, 150, N'roastbeef.jpg'),
(10, N'Салат «Мандрагора»',
     N'Свежий салат из шпината, грецких орехов и козьего сыра с медовой заправкой. Назван в честь кричащих мандрагор на уроке травологии.',
     6, 2, 15, N'salad.jpg')
GO

-- =============================================
-- 🥕 ИНГРЕДИЕНТЫ
-- =============================================
INSERT INTO [dbo].[Ingredients] ([IngredientID], [IngredientName]) VALUES
(1,  N'Тыква'),
(2,  N'Мука пшеничная'),
(3,  N'Масло сливочное'),
(4,  N'Сахар'),
(5,  N'Яйца'),
(6,  N'Корица'),
(7,  N'Мускатный орех'),
(8,  N'Молоко'),
(9,  N'Соль'),
(10, N'Картофель'),
(11, N'Говядина'),
(12, N'Лук репчатый'),
(13, N'Морковь'),
(14, N'Чеснок'),
(15, N'Шоколад тёмный'),
(16, N'Сливки'),
(17, N'Мёд'),
(18, N'Имбирь молотый'),
(19, N'Кофе'),
(20, N'Кардамон'),
(21, N'Шпинат'),
(22, N'Грецкие орехи'),
(23, N'Козий сыр'),
(24, N'Ванилин'),
(25, N'Разрыхлитель')
GO

-- =============================================
-- 📋 ИНГРЕДИЕНТЫ РЕЦЕПТОВ
-- =============================================
INSERT INTO [dbo].[RecipeIngredients] ([RecipeIngredientID], [RecipeID], [IngredientID], [Quantity]) VALUES
(1,  1, 1,  N'500 г'),
(2,  1, 2,  N'250 г'),
(3,  1, 3,  N'120 г'),
(4,  1, 4,  N'150 г'),
(5,  1, 5,  N'2 шт'),
(6,  1, 6,  N'1 ч.л.'),
(7,  1, 7,  N'0.5 ч.л.'),
(8,  4, 8,  N'400 мл'),
(9,  4, 4,  N'3 ст.л.'),
(10, 4, 3,  N'30 г'),
(11, 4, 24, N'1 ч.л.'),
(12, 5, 15, N'200 г'),
(13, 5, 16, N'50 мл'),
(14, 5, 17, N'1 ст.л.'),
(15, 6, 10, N'600 г'),
(16, 6, 11, N'400 г'),
(17, 6, 12, N'2 шт'),
(18, 6, 13, N'2 шт'),
(19, 6, 14, N'3 зубчика'),
(20, 7, 2,  N'300 г'),
(21, 7, 4,  N'100 г'),
(22, 7, 18, N'2 ч.л.'),
(23, 7, 3,  N'100 г'),
(24, 7, 5,  N'1 шт'),
(25, 7, 25, N'1 ч.л.'),
(26, 8, 19, N'2 ч.л.'),
(27, 8, 6,  N'0.5 ч.л.'),
(28, 8, 20, N'2 коробочки'),
(29, 8, 17, N'1 ст.л.'),
(30, 10, 21, N'100 г'),
(31, 10, 22, N'50 г'),
(32, 10, 23, N'80 г'),
(33, 10, 17, N'2 ст.л.')
GO

-- =============================================
-- 👣 ШАГИ ПРИГОТОВЛЕНИЯ
-- =============================================
INSERT INTO [dbo].[CookingSteps] ([StepID], [RecipeID], [StepNumber], [StepDescription]) VALUES
(1,  1, 1, N'Очистить тыкву, нарезать кубиками и запечь в духовке при 180°C до мягкости (30 мин).'),
(2,  1, 2, N'Измельчить тыкву в пюре, добавить яйца, сахар, корицу и мускатный орех, перемешать.'),
(3,  1, 3, N'Приготовить песочное тесто из муки, масла и щепотки соли. Раскатать и выложить в форму.'),
(4,  1, 4, N'Залить тыквенную начинку в форму. Выпекать 45 минут при 180°C до золотистой корочки.'),
(5,  4, 1, N'Нагреть молоко в кастрюле, не доводя до кипения.'),
(6,  4, 2, N'Добавить сахар, сливочное масло и ваниль. Перемешивать до растворения.'),
(7,  4, 3, N'Взбить отдельно сливки до мягких пиков и выложить сверху. Подавать тёплым.'),
(8,  5, 1, N'Растопить шоколад на водяной бане, добавить подогретые сливки и мёд.'),
(9,  5, 2, N'Вылить массу в силиконовые формочки в виде лягушек. Убрать в холодильник на 2 часа.'),
(10, 5, 3, N'Извлечь из форм и упаковать в фольгу. Внутрь вложить карточку с волшебником.'),
(11, 7, 1, N'Смешать муку, имбирь и разрыхлитель. В отдельной миске взбить масло с сахаром.'),
(12, 7, 2, N'Соединить все ингредиенты, замесить тесто. Убрать в холодильник на 30 минут.'),
(13, 7, 3, N'Раскатать тесто, вырезать фигурки. Выпекать 10 минут при 175°C.'),
(14, 7, 4, N'Остывшее печенье украсить цветной глазурью из сахарной пудры и лимонного сока.')
GO

-- =============================================
-- 🏷️ ТЕГИ РЕЦЕПТОВ
-- =============================================
INSERT INTO [dbo].[RecipeTags] ([RecipeTagID], [RecipeID], [TagID]) VALUES
(1,  1, 3),
(2,  1, 9),
(3,  2, 8),
(4,  2, 5),
(5,  3, 2),
(6,  4, 7),
(7,  4, 9),
(8,  5, 4),
(9,  5, 9),
(10, 6, 2),
(11, 7, 6),
(12, 7, 9),
(13, 8, 1),
(14, 8, 7),
(15, 9, 3),
(16, 10, 6),
(17, 10, 10)
GO

-- =============================================
-- ❤️ ЛАЙКИ
-- =============================================
INSERT INTO [dbo].[LikeRecipes] ([id], [idAuthor], [idRecipes]) VALUES
(1, 1, 4),
(2, 1, 5),
(3, 2, 1),
(4, 2, 10),
(5, 3, 2),
(6, 3, 6),
(7, 3, 9),
(8, 4, 3),
(9, 5, 8)
GO

-- =============================================
-- ⭐ ОТЗЫВЫ
-- =============================================
INSERT INTO [dbo].[Reviews] ([ReviewID], [RecipeID], [ReviewText], [Rating]) VALUES
(1, 4, N'Лучшее сливочное пиво, которое я пробовал! Точь-в-точь как в «Трёх метлах»!', 5),
(2, 1, N'Потрясающий пирог, бабушка Уизли была бы в восторге. Делаю каждое Рождество.', 5),
(3, 5, N'Прыгают не так высоко, как настоящие, но вкус — магический!', 4),
(4, 6, N'Сытно и вкусно. Хагрид одобряет.', 4),
(5, 8, N'Зелье бодрости действует. Даже лучше, чем пишут в учебниках Снейпа.', 5),
(6, 7, N'Мягкие, ароматные. Готовила с детьми — всем понравилось!', 5),
(7, 3, N'Наваристый суп, согревает в самую холодную зиму Хогсмида.', 4),
(8, 10, N'Лёгкий и свежий. Хороший перерыв между уроками.', 4)
GO

-- =============================================
-- 🖼️ ИЗОБРАЖЕНИЯ РЕЦЕПТОВ
-- =============================================
INSERT INTO [dbo].[RecipeImages] ([ImageID], [RecipeID], [ImagePath]) VALUES
(1,  1,  N'pumpkin_pie.jpg'),
(2,  4,  N'butterbeer.jpg'),
(3,  5,  N'choco_frog.jpg'),
(4,  6,  N'shepherd_pie.jpg'),
(5,  7,  N'ginger_cookies.jpg'),
(6,  8,  N'spiced_coffee.jpg'),
(7,  9,  N'roastbeef.jpg'),
(8,  10, N'salad.jpg')
GO
