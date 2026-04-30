namespace WpfApp1.ApplicationData
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Windows.Media.Imaging;

    public partial class Recipes
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Recipes()
        {
            this.CookingSteps = new HashSet<CookingSteps>();
            this.LikeRecipes = new HashSet<LikeRecipes>();
            this.RecipeImages = new HashSet<RecipeImages>();
            this.RecipeIngredients = new HashSet<RecipeIngredients>();
            this.RecipeTags = new HashSet<RecipeTags>();
            this.Reviews = new HashSet<Reviews>();
        }

        public int RecipeID { get; set; }
        public string RecipeName { get; set; }
        public string Description { get; set; }
        public Nullable<int> CategoryID { get; set; }
        public Nullable<int> AuthorID { get; set; }
        public Nullable<int> CookingTime { get; set; }
        public string Image { get; set; }

        public BitmapImage CurrentPhoto
        {
            get
            {
                // 📁 Путь к папке Images прямо в проекте
                string projectImagesDir = @"C:\Users\10240626\Source\Repos\CulinaryBook\WpfApp1\Images\";
                string zaglushka = Path.Combine(projectImagesDir, "zaglushka.jpg");
                string targetPath = zaglushka;

                if (!String.IsNullOrWhiteSpace(Image))
                {
                    string fileName = Path.GetFileName(Image);
                    string fullPath = Path.Combine(projectImagesDir, fileName);
                    if (File.Exists(fullPath))
                        targetPath = fullPath;
                }

                try
                {
                    BitmapImage bitmap = new BitmapImage();
                    bitmap.BeginInit();
                    bitmap.CacheOption = BitmapCacheOption.OnLoad;
                    bitmap.UriSource = new Uri(targetPath);
                    bitmap.EndInit();
                    return bitmap;
                }
                catch
                {
                    return null;
                }
            }
        }

        public virtual Authors Authors { get; set; }
        public virtual Categories Categories { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CookingSteps> CookingSteps { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<LikeRecipes> LikeRecipes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RecipeImages> RecipeImages { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RecipeIngredients> RecipeIngredients { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RecipeTags> RecipeTags { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Reviews> Reviews { get; set; }
    }
}
