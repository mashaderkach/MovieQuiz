import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Model (struct)
    
    // обертка для кастомных шрифтов
    private struct Fonts {
        static let ysDisplayBoldFontName = "YSDisplay-Bold"
        static let ysDisplayBold23 = UIFont(name: ysDisplayBoldFontName, size: 23)
        
        static let ysDisplayMediumFontName = "YSDisplay-Medium"
        static let ysDisplayMedium20 = UIFont(name: ysDisplayMediumFontName, size: 20)
    }
    
    // MARK: - Properties
    
    // индекс текущего вопроса (начальное значение 0)
    private var currentQuestionIndex = 0
    
    // счетчик правильных ответов (начальное значение 0)
    private var correctAnswers = 0
    
    // общее количество вопросов для квиза
    private let questionsAmount: Int = 10
    
    // фабрика вопросов. Контроллер будет обращаться за вопросами к ней
    private var questionFactory: QuestionFactoryProtocol?
    
    // вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    // объект для отображения алерта пользователю
    private var alertPresenter = AlertPresenter()
    
    private var statisticService: StatisticServiceProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        // cравниваем ответ пользователя с правильным и показываем результат
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        // cравниваем ответ пользователя с правильным и показываем результат
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
//        questionFactory.requestNextQuestion()
        
        showLoadingIndicator()
        questionFactory.loadData()
        
        textLabel.font = Fonts.ysDisplayBold23
        counterLabel.font = Fonts.ysDisplayMedium20
        yesButton.titleLabel?.font = Fonts.ysDisplayMedium20
        noButton.titleLabel?.font = Fonts.ysDisplayMedium20
        
        statisticService = StatisticService()
    }
    
    // MARK: - Data Conversation
    
    // преобразуем данные из модели QuizQuestion в формат QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//        return questionStep
    }
    
    // MARK: - Update Methods
    
    // показываем на экран вопрос, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // показываем рамку вокруг картинки с цветом результата, а потом переходим к следующему вопросу
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // код, который мы хотим вызвать через 1 секунду
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    

    // MARK: - Navigation
    
    // определяем, показывать следующий вопрос или уже результат квиза
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: resultViewModel)
            
        } else {
            
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Alert
    
    // отображаем алерт с результатами квиза
    private func show(quiz result: QuizResultsViewModel) {
        
        let gamePlayed = statisticService.gameCount
        let bestGame = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        
        let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(gamePlayed)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(accuracy)%
            """
        
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    
    private func showNetworkError(message: String) {
//        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
            }
        alertPresenter.show(in: self, model: model)  
    }
    
    
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // MARK: - Indicator
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
}



/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
