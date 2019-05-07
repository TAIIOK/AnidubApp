import UIKit

class TutorialViewController: UIViewController {

    var currentpage = 2;

    @IBOutlet weak var containerView: UIView!
    
    @IBAction func profilebutton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Profile") as! FifthViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialPageViewController?.scrollToNextViewController()
        tutorialPageViewController?.scrollToNextViewController()
        tutorialPageViewController?.scrollToNextViewController()
        tutorialPageViewController?.scrollToNextViewController()
        tutorialPageViewController?.scrollToNextViewController()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }

    @IBAction func didTapNextButton(_ sender: Any) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: currentpage)
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
        didUpdatePageCount count: Int) {
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
        didUpdatePageIndex index: Int) {
        currentpage = index
        self.title = "Новости"
        /*
        switch index {
        case 0:
            self.title = "Закладки Anidub"
        case 1:
            self.title = "Закладки Anilibria"
        case 2:
            self.title = "Новости"
        case 3:
            self.title = "Anidub"
        case 4:
            self.title = "Anilibria"
        default:
            self.title = "News"
        }
         */
    }
    
}
