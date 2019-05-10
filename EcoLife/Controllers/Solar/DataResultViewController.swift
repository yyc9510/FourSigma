//
//  DataResultViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 4/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView

class DataResultViewController: UIViewController {


    var user = Auth.auth().currentUser
    var ref: DatabaseReference!
    var postcode = ""
    var userLatitude: CLLocationDegrees
    var userLongitude: CLLocationDegrees
    var totalInstallations = ""
    var squ = ""
    var detailedAddress = ""
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var trendName: UILabel!
    @IBAction func installationButton(_ sender: Any) {
        performSegue(withIdentifier: "installationSegue", sender: "")
    }
    
    
    var installationRecord = [String]()
    var squRecord = [String]()
    
    var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var solarInstallation: UILabel!
    @IBOutlet weak var electricity: UILabel!
    @IBOutlet weak var solarStation: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let goBackButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.setImage(UIImage(named: "go_back.png"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressLabel.text = "\(self.detailedAddress)"
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.01)
        
        ref = Database.database().reference()
        self.readData(postcode: self.postcode)
        self.trendName.text = "Trend in \(self.detailedAddress)"
        
        // manage indicator
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(goBackButton)
        goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userLatitude = 0.0
        self.userLongitude = 0.0
        super.init(coder: aDecoder)!
    }
    
    @objc func goBack() {
        
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "Main") as? CustomTabBarController else { return }
        self.present(popupVC, animated:true, completion:nil)
        
    }
    
    func readData(postcode: String){
        
        let tmp = readIndex(input: postcode)
        if ((tmp as NSString).integerValue == 999) {
            let alert = UIAlertController(title: "Sorry...", message: "No data for this area!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            ref.child("solarByPostcode").child(tmp).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.totalInstallations = value?["InstallationsQuantityTotal"] as? String ?? "Null"
                self.squ = value?["SGURatedOutputInkWTotal"] as? String ?? "Null"
                
                self.installationRecord.append("\(value?["InstallationsQuantity201801"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201802"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201803"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201804"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201805"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201806"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201807"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201808"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201809"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201810"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201811"] ?? "0.0")")
                self.installationRecord.append("\(value?["InstallationsQuantity201812"] ?? "0.0")")
                
                self.squRecord.append("\(value?["SGURatedOutputInkW201801"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201802"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201803"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201804"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201805"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201806"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201807"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201808"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201809"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201810"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201811"] ?? "0.0")")
                self.squRecord.append("\(value?["SGURatedOutputInkW201812"] ?? "0.0")")
                
                
                DispatchQueue.main.async {
                    self.setLabel()
                }
                
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        
    }
    
    func setLabel() {
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("\(self.totalInstallations)")
            .normal(" houses are using Solar PVs")

        self.solarInstallation.attributedText = formattedString
        
        let formattedStringTwo = NSMutableAttributedString()
        formattedStringTwo
            .bold("\(self.squ)")
            .normal(" kW electricity was produced by these Solar PVs")
        self.electricity.attributedText = formattedStringTwo
        
        activityIndicator.stopAnimating()
    }
    
    
    
    func readIndex(input:String) -> String {
        let postcodeArray = [3000, 3002, 3003, 3004, 3006, 3008, 3011, 3012, 3013, 3015, 3016, 3018, 3019, 3020, 3021, 3022, 3023, 3024, 3025, 3026, 3027, 3028, 3029, 3030, 3031, 3032, 3033, 3034, 3036, 3037, 3038, 3039, 3040, 3041, 3042, 3043, 3044, 3045, 3046, 3047, 3048, 3049, 3051, 3052, 3053, 3054, 3055, 3056, 3057, 3058, 3059, 3060, 3061, 3062, 3063, 3064, 3065, 3066, 3067, 3068, 3070, 3071, 3072, 3073, 3074, 3075, 3076, 3078, 3079, 3081, 3082, 3083, 3084, 3085, 3087, 3088, 3089, 3090, 3091, 3093, 3094, 3095, 3096, 3097, 3099, 3101, 3102, 3103, 3104, 3105, 3106, 3107, 3108, 3109, 3111, 3113, 3114, 3115, 3116, 3121, 3122, 3123, 3124, 3125, 3126, 3127, 3128, 3129, 3130, 3131, 3132, 3133, 3134, 3135, 3136, 3137, 3138, 3139, 3140, 3141, 3142, 3143, 3144, 3145, 3146, 3147, 3148, 3149, 3150, 3151, 3152, 3153, 3154, 3155, 3156, 3158, 3159, 3160, 3161, 3162, 3163, 3164, 3165, 3166, 3167, 3168, 3169, 3170, 3171, 3172, 3173, 3174, 3175, 3176, 3177, 3178, 3179, 3180, 3181, 3182, 3183, 3184, 3185, 3186, 3187, 3188, 3189, 3190, 3191, 3192, 3193, 3194, 3195, 3196, 3197, 3198, 3199, 3200, 3201, 3202, 3204, 3205, 3206, 3207, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3218, 3219, 3220, 3221, 3222, 3223, 3224, 3225, 3226, 3227, 3228, 3230, 3231, 3232, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3240, 3241, 3242, 3243, 3249, 3250, 3251, 3254, 3260, 3264, 3265, 3266, 3267, 3268, 3269, 3270, 3271, 3272, 3273, 3274, 3275, 3276, 3277, 3278, 3279, 3280, 3281, 3282, 3283, 3284, 3285, 3286, 3287, 3289, 3292, 3293, 3294, 3300, 3301, 3302, 3303, 3304, 3305, 3309, 3310, 3311, 3312, 3314, 3315, 3317, 3318, 3319, 3321, 3322, 3323, 3324, 3325, 3328, 3329, 3330, 3331, 3332, 3333, 3334, 3335, 3336, 3337, 3338, 3340, 3341, 3342, 3345, 3350, 3351, 3352, 3353, 3354, 3355, 3356, 3357, 3358, 3360, 3361, 3363, 3364, 3370, 3371, 3373, 3374, 3375, 3377, 3378, 3379, 3380, 3381, 3384, 3385, 3387, 3388, 3390, 3391, 3392, 3393, 3395, 3396, 3400, 3401, 3402, 3407, 3409, 3412, 3413, 3414, 3415, 3418, 3419, 3420, 3423, 3424, 3427, 3428, 3429, 3430, 3431, 3432, 3433, 3434, 3435, 3437, 3438, 3440, 3441, 3442, 3444, 3446, 3447, 3448, 3450, 3451, 3453, 3458, 3460, 3461, 3462, 3463, 3464, 3465, 3467, 3468, 3469, 3472, 3475, 3477, 3478, 3480, 3482, 3483, 3485, 3487, 3488, 3489, 3490, 3491, 3494, 3496, 3498, 3500, 3501, 3502, 3505, 3506, 3507, 3509, 3512, 3515, 3516, 3517, 3518, 3520, 3521, 3522, 3523, 3525, 3527, 3529, 3530, 3531, 3533, 3537, 3540, 3542, 3544, 3546, 3549, 3550, 3551, 3552, 3554, 3555, 3556, 3557, 3558, 3559, 3561, 3562, 3563, 3564, 3565, 3566, 3567, 3568, 3570, 3571, 3572, 3573, 3575, 3576, 3579, 3580, 3581, 3583, 3584, 3585, 3586, 3588, 3589, 3590, 3591, 3594, 3595, 3596, 3597, 3599, 3607, 3608, 3610, 3612, 3614, 3616, 3617, 3618, 3619, 3620, 3621, 3622, 3623, 3624, 3629, 3630, 3631, 3632, 3633, 3634, 3635, 3636, 3637, 3638, 3639, 3640, 3641, 3643, 3644, 3646, 3647, 3649, 3658, 3659, 3660, 3661, 3662, 3663, 3664, 3665, 3666, 3669, 3670, 3671, 3672, 3673, 3675, 3676, 3677, 3678, 3682, 3683, 3685, 3687, 3688, 3689, 3690, 3691, 3694, 3695, 3697, 3698, 3699, 3700, 3701, 3704, 3705, 3707, 3708, 3709, 3711, 3712, 3713, 3714, 3715, 3717, 3718, 3719, 3720, 3722, 3723, 3724, 3725, 3726, 3727, 3728, 3730, 3732, 3733, 3735, 3736, 3737, 3738, 3739, 3740, 3741, 3744, 3746, 3747, 3749, 3750, 3751, 3752, 3753, 3754, 3755, 3756, 3757, 3758, 3759, 3760, 3761, 3762, 3763, 3764, 3765, 3766, 3767, 3770, 3775, 3777, 3778, 3779, 3781, 3782, 3783, 3786, 3787, 3788, 3789, 3791, 3792, 3793, 3795, 3796, 3797, 3799, 3802, 3803, 3804, 3805, 3806, 3807, 3808, 3809, 3810, 3812, 3813, 3814, 3815, 3816, 3818, 3820, 3821, 3822, 3823, 3824, 3825, 3831, 3832, 3833, 3835, 3840, 3842, 3844, 3847, 3850, 3851, 3852, 3853, 3854, 3856, 3857, 3858, 3859, 3860, 3862, 3864, 3865, 3869, 3870, 3871, 3873, 3874, 3875, 3878, 3880, 3882, 3885, 3886, 3887, 3888, 3889, 3890, 3891, 3892, 3893, 3895, 3896, 3898, 3900, 3902, 3903, 3904, 3909, 3910, 3911, 3912, 3913, 3915, 3916, 3918, 3919, 3921, 3922, 3923, 3925, 3926, 3927, 3928, 3929, 3930, 3931, 3933, 3934, 3936, 3937, 3938, 3939, 3940, 3941, 3942, 3943, 3944, 3945, 3946, 3950, 3951, 3953, 3954, 3956, 3957, 3958, 3959, 3960, 3962, 3964, 3965, 3966, 3967, 3971, 3975, 3976, 3977, 3978, 3979, 3980, 3981, 3984, 3987, 3988, 3990, 3991, 3992, 3995, 3996]
        
        let content = (input as NSString).integerValue
        let tmp = postcodeArray.firstIndex(of: content)
        return "\(tmp ?? 999)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "installationSegue") {
            let vc = segue.destination as! InstalltionChartViewController
            vc.installationRecord = self.installationRecord
            vc.squRecord = self.squRecord
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
