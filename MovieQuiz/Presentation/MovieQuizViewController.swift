import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation(userDefaults: Foundation.UserDefaults.standard,decoder: JSONDecoder(), encoder: JSONEncoder(), dateProvider: { Date() } )
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    private let presenter = MovieQuizPresenter()
   // private var currentQuestionIndex = 0
    private var correctAnswers = 0
    //private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробывать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
            // self.questionFactory?.loadData()
        }
        alertPresenter?.showQuizResult(model: model)
    }
    

    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    private func showAlert() {
        statisticService?.store(correct: correctAnswers, total: presenter.questionAmount)
        guard let statisticService = statisticService else {
            assertionFailure("error 1")
            return
        }
        guard let bestGame = statisticService.bestGame else {
            assertionFailure("error 2")
            return
        }
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message:
            """
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Ваш результат: \(correctAnswers)\\\(presenter.questionAmount)
            Рекорд: \(bestGame.correct)\\\(bestGame.total) \(bestGame.date.dateTimeString)
            Средняя точность \(String(format: "%.2f",statisticService.totalAccuracy))%
            """,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.resetQuestionIndex()
                self?.correctAnswers = 0
                //self?.questionFactory?.loadData()
                self?.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showQuizResult(model: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        
        if presenter.isLastQuestion() {
            showAlert()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            //questionFactory?.loadData()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = presenter.convert(model: question)
        self.show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    
}
