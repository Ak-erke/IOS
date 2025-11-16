import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var data: [[FavoriteItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func loadData() {
        // Добавляем элементы для каждой секции (как раньше)
        let movies = [
            FavoriteItem(image: UIImage(named: "movie1"), title: "Queen's Gambit", subtitle: "TV Series", review: "Интересная история о гениальности."),
            FavoriteItem(image: UIImage(named: "movie2"), title: "Хатико", subtitle: "Фильм", review: "Очень трогательный сюжет."),
            FavoriteItem(image: UIImage(named: "movie3"), title: "Интерстеллер", subtitle: "Christopher Nolan", review: "Глубокий космический фильм."),
            FavoriteItem(image: UIImage(named: "movie4"), title: "Паразит", subtitle: "Bong Joon-ho", review: "Сильный социальный триллер."),
            FavoriteItem(image: UIImage(named: "movie5"), title: "K-pop Demon Hunters", subtitle: "Movie", review: "Очень стильный и динамичный фильм.")
        ]


        let music = [
            FavoriteItem(image: UIImage(named: "music1"), title: "Gabriela", subtitle: "KATSEYE", review: "Очень приятный вайб."),  // вместо Katseye — Touch — официальный сингл группы KATSEYE :contentReference[oaicite:0]{index=0}
            FavoriteItem(image: UIImage(named: "music2"), title: "Blinding Lights", subtitle: "The Weeknd", review: "Один из лучших треков."),  // популярная песня The Weeknd :contentReference[oaicite:1]{index=1}
            FavoriteItem(image: UIImage(named: "music3"), title: "Like Jennie", subtitle: "Jennie", review: "Стильный и мощный трек."),  // Jennie — Mantra :contentReference[oaicite:2]{index=2}
            FavoriteItem(image: UIImage(named: "music4"), title: "Starboy", subtitle: "The Weeknd", review: "Красивый и атмосферный трек."),  // The Weeknd — Starboy :contentReference[oaicite:3]{index=3}
            FavoriteItem(image: UIImage(named: "music5"), title: "Call Out My Name", subtitle: "The Weeknd", review: "Очень эмоциональная песня.")
        ]



        let books = [
            FavoriteItem(image: UIImage(named: "book1"), title: "Оян, қазақ", subtitle: "М. Дулатов", review: "Классическое произведение казахской литературы."),
            FavoriteItem(image: UIImage(named: "book2"), title: "Бақытсыз Жамал", subtitle: "М. Әуезов", review: "Трогательная и глубокая история."),
            FavoriteItem(image: UIImage(named: "book3"), title: "Маленькие женщины", subtitle: "Луиза Мэй Олкотт", review: "Любимая классика о семье и взрослении."),
            FavoriteItem(image: UIImage(named: "book4"), title: "Менің атым — Қожа", subtitle: "Г. Мустафин", review: "Интересная история о детстве и взрослении."),
            FavoriteItem(image: UIImage(named: "book5"), title: "Конаев естелік эссе", subtitle: "Д. Конаев", review: "Познавательные и вдохновляющие эссе.")
        ]


        let courses = [
            FavoriteItem(image: UIImage(named: "course1"), title: "iOS Development", subtitle: "CS101", review: "Классный препод, хочется учиться!"),
            FavoriteItem(image: UIImage(named: "course2"), title: "Web Development", subtitle: "WD102", review: "Интересно и понятно."),
            FavoriteItem(image: UIImage(named: "course3"), title: "Power BI", subtitle: "BI103", review: "Легко усваивается, сразу практикуешь."),
            FavoriteItem(image: UIImage(named: "course4"), title: "PE", subtitle: "PE104", review: "Весело и активно."),
            FavoriteItem(image: UIImage(named: "course5"), title: "SQL", subtitle: "DB105", review: "Понятно и полезно.")
        ]


        data = [movies, music, books, courses]
        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource & Delegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        let item = data[indexPath.section][indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // Bonus: Custom Section Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black

        if let sectionType = SectionType(rawValue: section) {
            label.text = "\(sectionType.emoji) \(sectionType.title)"
        }

        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
