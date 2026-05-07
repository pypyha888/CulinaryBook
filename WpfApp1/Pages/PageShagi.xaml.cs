using System;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using WpfApp1.ApplicationData;

namespace WpfApp1.Pages
{
    public partial class PageShagi : Page
    {
        private Recipes _recipe;
        private readonly string _imagesDir = @"C:\Users\10240626\Source\Repos\CulinaryBook\WpfApp1\Images\";

        public PageShagi(Recipes recipe)
        {
            InitializeComponent();
            _recipe = recipe;
            tbTitle.Text = $"Шаги: {recipe.RecipeName}";
            LoadImage();
            LoadSteps();
        }

        // ── Загрузка данных ──────────────────────────────────────

        private void LoadSteps()
        {
            var steps = AppConnect.model01.CookingSteps
                .Where(s => s.RecipeID == _recipe.RecipeID)
                .OrderBy(s => s.StepNumber)
                .ToList();

            StepsList.ItemsSource = null;
            StepsList.ItemsSource = steps;
            tbStepCount.Text = $"Шагов: {steps.Count}";
        }

        private void LoadImage()
        {
            string zaglushka = Path.Combine(_imagesDir, "zaglushka.jpg");
            string target = zaglushka;

            if (!string.IsNullOrEmpty(_recipe.Image))
            {
                string full = Path.Combine(_imagesDir, Path.GetFileName(_recipe.Image));
                if (File.Exists(full)) target = full;
            }

            if (!File.Exists(target)) return;
            try
            {
                var bmp = new BitmapImage();
                bmp.BeginInit();
                bmp.CacheOption = BitmapCacheOption.OnLoad;
                bmp.UriSource = new Uri(target);
                bmp.EndInit();
                RecipeImage.Source = bmp;
            }
            catch { }
        }

        // ── Добавить шаг ─────────────────────────────────────────

        private void btnAddStep_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(StepDescBox.Text))
            {
                MessageBox.Show("Введите описание шага.", "Уведомление",
                    MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            try
            {
                int nextNum = AppConnect.model01.CookingSteps
                    .Where(s => s.RecipeID == _recipe.RecipeID)
                    .Select(s => (int?)s.StepNumber).Max() ?? 0;
                nextNum++;

                var step = new CookingSteps
                {
                    RecipeID = _recipe.RecipeID,
                    StepNumber = nextNum,
                    StepDescription = StepDescBox.Text.Trim()
                };

                AppConnect.model01.CookingSteps.Add(step);
                AppConnect.model01.SaveChanges();

                StepDescBox.Clear();
                LoadSteps();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка:\n{ex.Message}", "Ошибка",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // ── Удалить шаг ──────────────────────────────────────────

        private void btnDeleteStep_Click(object sender, RoutedEventArgs e)
        {
            if ((sender as Button)?.Tag is CookingSteps step)
            {
                try
                {
                    AppConnect.model01.CookingSteps.Remove(step);
                    AppConnect.model01.SaveChanges();
                    Renumber();
                    LoadSteps();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка:\n{ex.Message}", "Ошибка",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        // ── Переместить вверх/вниз ───────────────────────────────

        private void btnMoveUp_Click(object sender, RoutedEventArgs e)
        {
            if ((sender as Button)?.Tag is CookingSteps step && step.StepNumber > 1)
            {
                var prev = AppConnect.model01.CookingSteps
                    .FirstOrDefault(s => s.RecipeID == _recipe.RecipeID
                                      && s.StepNumber == step.StepNumber - 1);
                if (prev != null)
                {
                    prev.StepNumber++;
                    step.StepNumber--;
                    AppConnect.model01.SaveChanges();
                    LoadSteps();
                }
            }
        }

        private void btnMoveDown_Click(object sender, RoutedEventArgs e)
        {
            if ((sender as Button)?.Tag is CookingSteps step)
            {
                var next = AppConnect.model01.CookingSteps
                    .FirstOrDefault(s => s.RecipeID == _recipe.RecipeID
                                      && s.StepNumber == step.StepNumber + 1);
                if (next != null)
                {
                    next.StepNumber--;
                    step.StepNumber++;
                    AppConnect.model01.SaveChanges();
                    LoadSteps();
                }
            }
        }

        // ── Утилиты ──────────────────────────────────────────────

        private void Renumber()
        {
            var steps = AppConnect.model01.CookingSteps
                .Where(s => s.RecipeID == _recipe.RecipeID)
                .OrderBy(s => s.StepNumber)
                .ToList();

            for (int i = 0; i < steps.Count; i++)
                steps[i].StepNumber = i + 1;

            AppConnect.model01.SaveChanges();
        }

        // ── Навигация ─────────────────────────────────────────────

        private void btnBack_Click(object sender, RoutedEventArgs e)
        {
            ApplicationData.AppFrame.frmMain.Navigate(new AddRecip(_recipe));
        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Шаги сохранены!", "✅ Готово",
                MessageBoxButton.OK, MessageBoxImage.Information);
            ApplicationData.AppFrame.frmMain.Navigate(new PageTask());
        }
    }
}
