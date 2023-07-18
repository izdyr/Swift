import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let apiKey = "YOUR_API_KEY_FROM_OpenWeather"
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Search", message: "Enter city name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "City name"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default) { action in
            if let cityName = alert.textFields?.first?.text, !cityName.isEmpty {
                self.fetchWeatherData(for: cityName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(searchAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func fetchWeatherData(for city: String) {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching weather data: \(error.localizedDescription)")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        self.weatherData = try decoder.decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.updateUI()
                        }
                    } catch {
                        print("Error decoding weather data: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func updateUI() {
        if let weatherData = weatherData {
            cityLabel.text = weatherData.name
            temperatureLabel.text = "\(Int(weatherData.main.temp))ºC"
            descriptionLabel.text = weatherData.weather.first?.description.capitalized
            if let iconName = weatherData.weather.first?.icon {
                if let iconUrl = URL(string: "https://openweathermap.org/img/w/\(iconName).png") {
                    let task = URLSession.shared.dataTask(with: iconUrl) { (data, response, error) in
                        if let error = error {
                            print("Error fetching icon data: \(error.localizedDescription)")
                        } else if let data = data {
                            DispatchQueue.main.async {
                                self.iconImageView.image = UIImage(data: data)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let icon: String
}
