using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using WpfApp1.ApplicationData;

namespace WpfApp1.Pages
{
    /// <summary>
    /// 🍲 Страница добавления / редактирования рецепта
    /// </summary>
    public partial class AddRecip : Page
    {
        private Recipes _recipe;

        // 📁 Путь к папке с изображениями проекта
        private readonly string _imagesDir = @"C:\Users\10240626\Source\Repos\CulinaryBook\WpfApp1\Images\";

        public AddRecip(Recipes recipe = null)
        {
            InitializeComponent();
            _recipe = recipe ?? new Recipes();
            FillCategories();
            FillAuthors();

            if (recipe != null)
                LoadRecipeData(recipe);
            else
                LoadImageToPictureBox(Path.Combine(_imagesDir, "zaglushka.jpg")); // заглушка для нового
        }

        private void FillCategories()
        {
            CategoryCombo.Items.Clear();
            CategoryCombo.Items.Add("📁 Выбор категории");
            CategoryCombo.SelectedIndex = 0;
            foreach (var c in AppConnect.model01.Categories)
                CategoryCombo.Items.Add(c.CategoryName);
        }

        private void FillAuthors()
        {
            AuthorCombo.Items.Clear();
            AuthorCombo.Items.Add("🧙 Выбор автора");
            AuthorCombo.SelectedIndex = 0;
            foreach (var a in AppConnect.model01.Authors)
                AuthorCombo.Items.Add(a.AuthorName);
        }

        private void LoadRecipeData(Recipes recipe)
        {
            NameRecepis.Text = recipe.RecipeName;
            DescRecipes.Text = recipe.Description;
            TextTime.Text = recipe.CookingTime?.ToString();
            TextPage.Text = recipe.Image;

            if (recipe.CategoryID.HasValue && recipe.CategoryID.Value < CategoryCombo.Items.Count)
                CategoryCombo.SelectedIndex = recipe.CategoryID.Value;

            if (recipe.AuthorID.HasValue && recipe.AuthorID.Value < AuthorCombo.Items.Count)
                AuthorCombo.SelectedIndex = recipe.AuthorID.Value;

            // 🖼️ Загружаем картинку или заглушку
            string zaglushka = Path.Combine(_imagesDir, "zaglushka.jpg");
            if (!string.IsNullOrEmpty(recipe.Image))
            {
                string imagePath = Path.Combine(_imagesDir, Path.GetFileName(recipe.Image));
                LoadImageToPictureBox(File.Exists(imagePath) ? imagePath : zaglushka);
            }
            else
            {
                LoadImageToPictureBox(zaglushka);
            }
        }

        private void AddRecep_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(NameRecepis.Text) ||
                    string.IsNullOrWhiteSpace(DescRecipes.Text) ||
                    string.IsNullOrWhiteSpace(TextTime.Text) ||
                    CategoryCombo.SelectedIndex == 0 ||
                    AuthorCombo.SelectedIndex == 0)
                {
                    MessageBox.Show("Не заполнены все поля!", "📖 Уведомление",
                        MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }

                if (!int.TryParse(TextTime.Text, out int cookingTime) || cookingTime <= 0)
                {
                    MessageBox.Show("Введите корректное время приготовления (целое число)!", "📖 Уведомление",
                        MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                _recipe.RecipeName = NameRecepis.Text.Trim();
                _recipe.Description = DescRecipes.Text.Trim();
                _recipe.CategoryID = CategoryCombo.SelectedIndex;
                _recipe.AuthorID = AuthorCombo.SelectedIndex;
                _recipe.CookingTime = cookingTime;
                _recipe.Image = TextPage.Text;

                if (_recipe.RecipeID == 0)
                    AppConnect.model01.Recipes.Add(_recipe);

                AppConnect.model01.SaveChanges();

                MessageBox.Show("✨ Данные успешно добавлены!", "✅ Успех",
                    MessageBoxButton.OK, MessageBoxImage.Information);

                ApplicationData.AppFrame.frmMain.Navigate(new PageTask());
            }
            catch (Exception ex)
            {
                MessageBox.Show($"💥 Ошибка при добавлении данных:\n{ex.Message}", "Ошибка",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void HomeWorld_Click(object sender, RoutedEventArgs e)
        {
            ApplicationData.AppFrame.frmMain.Navigate(new PageTask());
        }

        private void LoadImage_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new Microsoft.Win32.OpenFileDialog
            {
                Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files|*.*",
                Title = "Выберите изображение"
            };

            if (dialog.ShowDialog() == true)
            {
                try
                {
                    string photoName = Path.GetFileName(dialog.FileName);

                    if (!Directory.Exists(_imagesDir))
                        Directory.CreateDirectory(_imagesDir);

                    string destinationPath = Path.Combine(_imagesDir, photoName);
                    File.Copy(dialog.FileName, destinationPath, true);

                    _recipe.Image = photoName;
                    TextPage.Text = photoName;
                    LoadImageToPictureBox(destinationPath);

                    MessageBox.Show($"📸 Изображение загружено: {photoName}", "✅ Успех",
                        MessageBoxButton.OK, MessageBoxImage.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"💥 Ошибка при загрузке изображения:\n{ex.Message}", "Ошибка",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void LoadImageToPictureBox(string imagePath)
        {
            if (!File.Exists(imagePath)) return;
            try
            {
                BitmapImage bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                bitmap.UriSource = new Uri(imagePath);
                bitmap.EndInit();
                pictureBox.Source = bitmap;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"💥 Ошибка при отображении изображения:\n{ex.Message}");
            }
        }
        private void Shagi_Click(object sender, RoutedEventArgs e)
        {
            ApplicationData.AppFrame.frmMain.Navigate(new PageShagi(_recipe));
        }
    }
}
