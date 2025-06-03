import UIKit
import SnapKit

class TimerDialViewController: UIViewController {
    
    private var timeLabel: UILabel!
    private var hourHand: CAShapeLayer!
    private var minuteHand: CAShapeLayer!
    private var secondHand: CAShapeLayer!
    private var milisecondHand: CAShapeLayer!
    
    private var startDate: Date?
    var startTimerButton = UIButton(type: .custom)
    var stopTimerButton = UIButton(type: .custom)
    
    var timer = TimerManager.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        startTimerButton.addTarget(self, action: #selector(startButtonAction(_:)), for: .touchUpInside)
        stopTimerButton.addTarget(self, action: #selector(stopButtonAction(_:)), for: .touchUpInside)

       
        // Запускаем таймер
       //startTimer()
    }
    
    private func setupViews(){
        
        startTimerButton.frame = CGRect(x: view.bounds.width-105, y: view.bounds.height*0.2, width: 100, height: 50)
        startTimerButton.setTitle("START", for: .normal)
        startTimerButton.tintColor = .black
        startTimerButton.backgroundColor = .green
        startTimerButton.layer.cornerRadius = 15
        startTimerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startTimerButton)
        
        stopTimerButton.frame = CGRect(x: view.bounds.width-105, y: view.bounds.height*0.27, width: 100, height: 50)
        stopTimerButton.setTitle("STOP", for: .normal)
        stopTimerButton.tintColor = .black
        stopTimerButton.backgroundColor = .lightGray
        stopTimerButton.layer.cornerRadius = 15
        stopTimerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopTimerButton)
        
        
        // Настраиваем фон
        view.backgroundColor = UIColor.systemBackground
        
        // Размер циферблата
        let dialSize: CGFloat = 220
        
        // Создаём циферблат
        let dialView = UIView(frame: CGRect(x: 0, y: 30, width: dialSize, height: dialSize))
       // dialView.center = view.center
        dialView.backgroundColor = .clear
        view.addSubview(dialView)
        
        // Добавляем объемный круг
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = dialView.bounds
        gradientLayer.colors = [
            UIColor(white: 0.9, alpha: 1).cgColor,
            UIColor(white: 0.7, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.7)
        gradientLayer.cornerRadius = dialSize / 2
        dialView.layer.addSublayer(gradientLayer)
        
        // Обводка циферблата
        let borderLayer = CAShapeLayer()
        let borderPath = UIBezierPath(ovalIn: dialView.bounds.insetBy(dx: 5, dy: 5))
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = UIColor.darkGray.cgColor
        borderLayer.lineWidth = 8
        borderLayer.fillColor = UIColor.clear.cgColor
        dialView.layer.addSublayer(borderLayer)
        
        // Деления циферблата
        addTickMarks(to: dialView, dialSize: dialSize)
        
        // Добавляем стрелки
        hourHand = createHand(dialView: dialView, lengthRatio: 0.5, width: 6, color: UIColor.black)
        minuteHand = createHand(dialView: dialView, lengthRatio: 0.7, width: 4, color: UIColor.darkGray)
        secondHand = createHand(dialView: dialView, lengthRatio: 0.9, width: 2, color: UIColor.red)
        milisecondHand = createHand(dialView: dialView, lengthRatio: 1.0, width: 1.5, color: UIColor.green)
        
        
        // Центральный круг
        let centerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        centerCircle.center = CGPoint(x: dialView.bounds.midX, y: dialView.bounds.midY)
        centerCircle.backgroundColor = .black
        centerCircle.layer.cornerRadius = 10
        centerCircle.layer.borderWidth = 2
        centerCircle.layer.borderColor = UIColor.white.cgColor
        dialView.addSubview(centerCircle)
        
        // Лейбл с цифровым временем
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialSize - 10, height: 50))
        timeLabel.center = CGPoint(x: dialView.bounds.midX, y: dialView.bounds.midY + 30)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .bold)
        timeLabel.textColor = .black
        timeLabel.text = "00:00:00"
        timeLabel.layer.shadowColor = UIColor.black.cgColor
        timeLabel.layer.shadowOpacity = 0.25
        timeLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        timeLabel.layer.shadowRadius = 2
        dialView.addSubview(timeLabel)
    }
    
    @objc func startButtonAction(_ sender: UIButton) {
        // Начало измерения времени
        startDate = Date()
        
        print("New button start is started")
        
        // Запускаем таймер
        //timer.startTimer()
        startTimer()
        }
    
    @objc func stopButtonAction(_ sender: UIButton) {
        // Сбрасываем начальное время
        startDate = nil
        print("__________----------STOP TIMER____________------------")
        // Останавливаем таймер
        // Тут надо сохранить ссылку на таймер и вызвать invalidate(), но мы пока можем оставить так
        timer.invTimer()
    }
    
    // Функция создания стрелки
    private func createHand(dialView: UIView, lengthRatio: CGFloat, width: CGFloat, color: UIColor) -> CAShapeLayer {
        let handLayer = CAShapeLayer()
        let handPath = UIBezierPath()
        let center = CGPoint(x: dialView.bounds.width / 2, y: dialView.bounds.height / 2)
        let end = CGPoint(
            x: center.x,
            y: center.y - (dialView.bounds.height / 2 * lengthRatio)
        )
        handPath.move(to: center)
        handPath.addLine(to: end)
        
        handLayer.path = handPath.cgPath
        handLayer.strokeColor = color.cgColor
        handLayer.lineWidth = width
        handLayer.lineCap = .round
        handLayer.bounds = dialView.bounds
        handLayer.position = center
        handLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        handLayer.zPosition = 1
        dialView.layer.addSublayer(handLayer)
        return handLayer
    }
    
    // Функция добавления делений
    private func addTickMarks(to view: UIView, dialSize: CGFloat) {
        for i in 0..<60 {
            let angle = CGFloat(i) * CGFloat.pi / 30
            let tickLength: CGFloat = i % 5 == 0 ? 15 : 7
            let tickWidth: CGFloat = i % 5 == 0 ? 3 : 1
            
            let tickLayer = CAShapeLayer()
            let center = CGPoint(x: dialSize / 2, y: dialSize / 2)
            let start = CGPoint(
                x: center.x + cos(angle) * (dialSize / 2 - 20),
                y: center.y + sin(angle) * (dialSize / 2 - 20)
            )
            let end = CGPoint(
                x: center.x + cos(angle) * (dialSize / 2 - 20 - tickLength),
                y: center.y + sin(angle) * (dialSize / 2 - 20 - tickLength)
            )
            
            let tickPath = UIBezierPath()
            tickPath.move(to: start)
            tickPath.addLine(to: end)
            
            tickLayer.path = tickPath.cgPath
            tickLayer.strokeColor = UIColor.black.cgColor
            tickLayer.lineWidth = tickWidth
            view.layer.addSublayer(tickLayer)
        }
    }
    
    // Обновление времени
    private func startTimer() {
        timer.startTimer()
           let currentDate = Date()
           
           // Начинаем отсчет только если установлено стартовое время
           guard let startDate = startDate else { return }
           
           // Прошедшее время с момента старта
           let elapsedTime = currentDate.timeIntervalSince(startDate)
           
           // Конвертируем в часы, минуты и секунды
           let hours = Int(elapsedTime / 3600)
           let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
           let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
           
           // Обновляем лейбл
           self.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
           
           // Обновляем стрелки (при желании)
           let secondAngle = CGFloat(seconds) * CGFloat.pi / 30
           let minuteAngle = (CGFloat(minutes) + CGFloat(seconds) / 60) * CGFloat.pi / 30
           let hourAngle = (CGFloat(hours % 12) + CGFloat(minutes) / 60) * CGFloat.pi / 6
           
           self.secondHand.transform = CATransform3DMakeRotation(secondAngle, 0, 0, 1)
           self.minuteHand.transform = CATransform3DMakeRotation(minuteAngle, 0, 0, 1)
           self.hourHand.transform = CATransform3DMakeRotation(hourAngle, 0, 0, 1)
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            let now = Date()
//            let startTime = Date()
//            var elTime = Date().timeIntervalSince(startTime)
//            let calendar = Calendar.current
//            let hours = calendar.component(.hour, from: now)
//            let minutes = calendar.component(.minute, from: now)
//            let seconds = calendar.component(.second, from: now)
//
//            // Обновляем лейбл
//            self.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//
//            // Обновляем стрелки
//            let secondAngle = CGFloat(seconds) * CGFloat.pi / 30
//            let minuteAngle = (CGFloat(minutes) + CGFloat(seconds) / 60) * CGFloat.pi / 30
//            let hourAngle = (CGFloat(hours % 12) + CGFloat(minutes) / 60) * CGFloat.pi / 6
//
//            self.secondHand.transform = CATransform3DMakeRotation(secondAngle, 0, 0, 1)
//            self.minuteHand.transform = CATransform3DMakeRotation(minuteAngle, 0, 0, 1)
//            self.hourHand.transform = CATransform3DMakeRotation(hourAngle, 0, 0, 1)
        }
    }
    
    

