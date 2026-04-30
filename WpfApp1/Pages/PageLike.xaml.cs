// Pages/PageLike.xaml.cs
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using WpfApp1.ApplicationData;

namespace WpfApp1.Pages
{
    /// <summary>
    /// ❤️ Страница избранных рецептов (PageLike)
    /// Алгоритм:
    /// 1. При открытии страницы вызывается UpdateLikeRecipes()
    /// 2. Из таблицы LikeRecipes выбираются ID рецептов текущего пользователя
    /// 3. По этим ID загружаются полные данные рецептов из таблицы Recipes
    /// 4. Список привязывается к listProducts
    /// 5. При удалении из избранного — список обновляется
    /// </summary>
    public partial class PageLike : Page
    {
        // Список рецептов для хранения текущих данных
        private System.Collections.Generic.List<Recipes> recipes;

        public PageLike()
        {
            InitializeComponent();

            // Загрузка избранных рецептов при открытии страницы
            UpdateLikeRecipes();
        }

        /// <summary>
        /// 🔄 Загрузка и отображение избранных рецептов текущего пользователя
        /// </summary>
        private void UpdateLikeRecipes()
        {
            try
            {
                // 1. Получение списка ID избранных рецептов текущего пользователя
                var likeRecipes = AppConnect.model01.LikeRecipes
                    .Where(x => x.idAuthor == AppConnect.AuthorID)
                    .Select(x => x.idRecipes)
                    .ToList();

                // 2. Загрузка полных данных рецептов по найденным ID
                recipes = AppConnect.model01.Recipes
                    .Where(x => likeRecipes.Contains(x.RecipeID))
                    .ToList();

                // 3. Привязка данных к интерфейсу
                listProducts.ItemsSource = recipes;
                myGridView.ItemsSource = recipes;

                // 4. Обновление счётчика
                UpdateCounter();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке избранного:\n{ex.Message}",
                    "💥 Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        /// <summary>
        /// 📊 Обновление счётчика рецептов в нижней панели
        /// </summary>
        private void UpdateCounter()
        {
            if (recipes != null && recipes.Count > 0)
            {
                tbCounter.Text = $"❤️ Избранных рецептов: {recipes.Count}";
                tbCounter.Foreground = System.Windows.Media.Brushes.LightGreen;
            }
            else
            {
                tbCounter.Text = "😔 Вы ещё не добавили рецепты в избранное";
                tbCounter.Foreground = System.Windows.Media.Brushes.LightCoral;
            }
        }

        /// <summary>
        /// 🗑️ Удаление рецепта из избранного
        /// </summary>
        private void btnDelete_Click(object sender, RoutedEventArgs e)
        {
            var button = sender as Button;
            if (button?.Tag is Recipes selectedRecipe)
            {
                try
                {
                    // Находим запись в таблице LikeRecipes
                    var likeEntry = AppConnect.model01.LikeRecipes
                        .FirstOrDefault(x =>
                            x.idAuthor == AppConnect.AuthorID &&
                            x.idRecipes == selectedRecipe.RecipeID);

                    if (likeEntry != null)
                    {
                        AppConnect.model01.LikeRecipes.Remove(likeEntry);
                        AppConnect.model01.SaveChanges();

                        MessageBox.Show(
                            $"Рецепт \"{selectedRecipe.RecipeName}\" удалён из избранного.",
                            "📖 Информация", MessageBoxButton.OK, MessageBoxImage.Information);

                        // Обновляем список после удаления
                        UpdateLikeRecipes();
                    }
                }
                catch (System.Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении из избранного:\n{ex.Message}",
                        "💥 Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        /// <summary>
        /// 🖱️ Двойной клик — просмотр рецепта
        /// </summary>
        private void listProducts_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (listProducts.SelectedItem is Recipes selectedRecipe)
            {
                AppFrame.frmMain.Navigate(new AddRecip(selectedRecipe));
            }
        }

        /// <summary>
        /// 📋 Переключение на вид списка
        /// </summary>
        private void Button_Click_List(object sender, RoutedEventArgs e)
        {
            listProducts.Visibility = Visibility.Visible;
            myGridView.Visibility = Visibility.Collapsed;
        }

        /// <summary>
        /// 🧙 Переключение на вид плитки
        /// </summary>
        private void Button_Click_Grid(object sender, RoutedEventArgs e)
        {
            listProducts.Visibility = Visibility.Collapsed;
            myGridView.Visibility = Visibility.Visible;
        }

        /// <summary>
        /// ◀ Возврат на главную страницу рецептов
        /// </summary>
        private void btnBack_Click(object sender, RoutedEventArgs e)
        {
            AppFrame.frmMain.Navigate(new PageTask());
        }
    }
}
