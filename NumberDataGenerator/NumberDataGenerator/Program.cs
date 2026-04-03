

using System.Reflection;
internal class Program
{
    private static void Main(string[] args)
    {
        string? basePath = Path.GetDirectoryName(Assembly.GetEntryAssembly()?.Location);
        Dictionary<string, int> amounts = new()
        {
            ["10K"] = 10_000,
            ["50K"] = 50_000,
            ["100K"] = 100_000,
            ["500K"] = 500_000,
            ["1M"] = 1_000_000
        };

        Random rng = new Random();

        foreach (var entry in amounts)
        {
            string sizeLabel = entry.Key;
            int n = entry.Value;

            SaveDataset(basePath, $"Sorted_{sizeLabel}.txt", GenerateSorted(n));
            SaveDataset(basePath, $"Reverse_{sizeLabel}.txt", GenerateReverseSorted(n));

            // Om dubbele waarden te voorkomen gebruiken we n*10 zodat de range in verschillende waardes groter zijn dan het aantal waardes dat 

            SaveDataset(basePath, $"Uniform_{sizeLabel}.txt", GenerateUniformRandom(n, 0, n * 10, rng));
            SaveDataset(basePath, $"NearlySorted_{sizeLabel}.txt", GenerateNearlySorted(n, n / 100, rng));
        }
    }

    static void SaveDataset(string? basePath, string fileName, IEnumerable<int> data)
    {
        if (basePath == null) return;

        string folder = Path.Combine(basePath, "Data");
        Directory.CreateDirectory(folder);

        string fullPath = Path.Combine(folder, fileName);
        File.WriteAllLines(fullPath, data.Select(x => x.ToString()));
    }

    static List<int> GenerateSorted(int n)
    {
        return Enumerable.Range(0, n).ToList();
    }

    static List<int> GenerateReverseSorted(int n)
    {
        return Enumerable.Range(0, n).Reverse().ToList();
    }

    static List<int> GenerateUniformRandom(int n, int min, int max, Random rng)
    {
        List<int> data = new(n);
        for (int i = 0; i < n; i++)
            data.Add(rng.Next(min, max));
        return data;
    }

    static List<int> GenerateNearlySorted(int n, int swaps, Random rng)
    {
        // We first generate a sorted list
        List<int> data = GenerateSorted(n);

        // We will run this loop for 'swaps' times
        for (int i = 0; i < swaps; i++)
        {
            //We will just swap some random data entries with each other
            int a = rng.Next(n);
            int b = rng.Next(n);
            (data[a], data[b]) = (data[b], data[a]);
        }

        return data;
    }
}