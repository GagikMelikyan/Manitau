import UIKit

class IndikatorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit () {
        Bundle.main.loadNibNamed("IndikatorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "IndikatorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("Indicatro created")
    }
    */
}
