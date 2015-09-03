

import UIKit

class ViewController : UIViewController {
    
    /*
    The problem is that dynamic type is not actually dynamic!
    Updating the interface is up to you.
*/
    
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doDynamicType:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
//        UIFont.familyNames().map {UIFont.fontNamesForFamilyName($0)}
//            .forEach {(n:[String]) in n.forEach {print($0)}}
        
        // that's not what I actually used to get this list:

        /*
        
        Thonburi ["Thonburi-Bold", "Thonburi", "Thonburi-Light"]
        Khmer Sangam MN ["KhmerSangamMN"]
        Kohinoor Telugu ["KohinoorTelugu-Regular", "KohinoorTelugu-Light", "KohinoorTelugu-Medium"]
        Snell Roundhand ["SnellRoundhand-Black", "SnellRoundhand-Bold", "SnellRoundhand"]
        Academy Engraved LET ["AcademyEngravedLetPlain"]
        Marker Felt ["MarkerFelt-Thin", "MarkerFelt-Wide"]
        Avenir ["Avenir-Heavy", "Avenir-Oblique", "Avenir-Black", "Avenir-Book", "Avenir-BlackOblique", "Avenir-HeavyOblique", "Avenir-Light", "Avenir-MediumOblique", "Avenir-Medium", "Avenir-LightOblique", "Avenir-Roman", "Avenir-BookOblique"]
        Geeza Pro ["GeezaPro-Bold", "GeezaPro"]
        Arial Rounded MT Bold ["ArialRoundedMTBold"]
        Trebuchet MS ["Trebuchet-BoldItalic", "TrebuchetMS", "TrebuchetMS-Bold", "TrebuchetMS-Italic"]
        Arial ["ArialMT", "Arial-BoldItalicMT", "Arial-ItalicMT", "Arial-BoldMT"]
        Menlo ["Menlo-BoldItalic", "Menlo-Regular", "Menlo-Bold", "Menlo-Italic"]
        Gurmukhi MN ["GurmukhiMN-Bold", "GurmukhiMN"]
        Malayalam Sangam MN ["MalayalamSangamMN", "MalayalamSangamMN-Bold"]
        Kannada Sangam MN ["KannadaSangamMN", "KannadaSangamMN-Bold"]
        Bradley Hand ["BradleyHandITCTT-Bold"]
        Bodoni 72 Oldstyle ["BodoniSvtyTwoOSITCTT-BookIt", "BodoniSvtyTwoOSITCTT-Bold", "BodoniSvtyTwoOSITCTT-Book"]
        Cochin ["Cochin-Bold", "Cochin-BoldItalic", "Cochin-Italic", "Cochin"]
        Sinhala Sangam MN ["SinhalaSangamMN", "SinhalaSangamMN-Bold"]
        PingFang HK ["PingFangHK-Light", "PingFangHK-Semibold", "PingFangHK-Thin", "PingFangHK-Medium", "PingFangHK-Ultralight", "PingFangHK-Regular"]
        Iowan Old Style ["IowanOldStyle-Bold", "IowanOldStyle-BoldItalic", "IowanOldStyle-Italic", "IowanOldStyle-Roman"]
        Kohinoor Bangla ["KohinoorBangla-Semibold", "KohinoorBangla-Regular", "KohinoorBangla-Light"]
        Damascus ["DamascusBold", "Damascus", "DamascusLight", "DamascusMedium", "DamascusSemiBold"]
        Al Nile ["AlNile-Bold", "AlNile"]
        Farah ["Farah"]
        Papyrus ["Papyrus-Condensed", "Papyrus"]
        Verdana ["Verdana-BoldItalic", "Verdana-Italic", "Verdana", "Verdana-Bold"]
        Zapf Dingbats ["ZapfDingbatsITC"]
        Avenir Next Condensed ["AvenirNextCondensed-Regular", "AvenirNextCondensed-MediumItalic", "AvenirNextCondensed-UltraLightItalic", "AvenirNextCondensed-UltraLight", "AvenirNextCondensed-BoldItalic", "AvenirNextCondensed-Italic", "AvenirNextCondensed-Medium", "AvenirNextCondensed-HeavyItalic", "AvenirNextCondensed-Heavy", "AvenirNextCondensed-DemiBoldItalic", "AvenirNextCondensed-DemiBold", "AvenirNextCondensed-Bold"]
        Courier ["Courier", "Courier-Oblique", "Courier-BoldOblique", "Courier-Bold"]
        Hoefler Text ["HoeflerText-Regular", "HoeflerText-BlackItalic", "HoeflerText-Italic", "HoeflerText-Black"]
        Euphemia UCAS ["EuphemiaUCAS", "EuphemiaUCAS-Bold", "EuphemiaUCAS-Italic"]
        Helvetica ["Helvetica-Oblique", "Helvetica-Light", "Helvetica-Bold", "Helvetica", "Helvetica-BoldOblique", "Helvetica-LightOblique"]
        Lao Sangam MN ["LaoSangamMN"]
        Hiragino Mincho ProN ["HiraMinProN-W6", "HiraMinProN-W3"]
        Bodoni Ornaments ["BodoniOrnamentsITCTT"]
        Apple Color Emoji ["AppleColorEmoji"]
        Mishafi ["DiwanMishafi"]
        Optima ["Optima-Regular", "Optima-Italic", "Optima-Bold", "Optima-BoldItalic", "Optima-ExtraBlack"]
        Gujarati Sangam MN ["GujaratiSangamMN-Bold", "GujaratiSangamMN"]
        Devanagari Sangam MN ["DevanagariSangamMN", "DevanagariSangamMN-Bold"]
        PingFang SC ["PingFangSC-Semibold", "PingFangSC-Regular", "PingFangSC-Thin", "PingFangSC-Light", "PingFangSC-Ultralight", "PingFangSC-Medium"]
        Savoye LET ["SavoyeLetPlain"]
        Times New Roman ["TimesNewRomanPS-BoldItalicMT", "TimesNewRomanPSMT", "TimesNewRomanPS-BoldMT", "TimesNewRomanPS-ItalicMT"]
        Kailasa ["Kailasa", "Kailasa-Bold"]
        Telugu Sangam MN is empty
        Heiti SC is empty
        Apple SD Gothic Neo ["AppleSDGothicNeo-Thin", "AppleSDGothicNeo-UltraLight", "AppleSDGothicNeo-SemiBold", "AppleSDGothicNeo-Medium", "AppleSDGothicNeo-Regular", "AppleSDGothicNeo-Bold", "AppleSDGothicNeo-Light"]
        Futura ["Futura-Medium", "Futura-CondensedMedium", "Futura-MediumItalic", "Futura-CondensedExtraBold"]
        Bodoni 72 ["BodoniSvtyTwoITCTT-Book", "BodoniSvtyTwoITCTT-Bold", "BodoniSvtyTwoITCTT-BookIta"]
        Baskerville ["Baskerville-Bold", "Baskerville-SemiBoldItalic", "Baskerville-BoldItalic", "Baskerville", "Baskerville-SemiBold", "Baskerville-Italic"]
        Symbol ["Symbol"]
        Heiti TC is empty
        Copperplate ["Copperplate", "Copperplate-Light", "Copperplate-Bold"]
        Party LET ["PartyLetPlain"]
        American Typewriter ["AmericanTypewriter-Light", "AmericanTypewriter-CondensedLight", "AmericanTypewriter-CondensedBold", "AmericanTypewriter", "AmericanTypewriter-Condensed", "AmericanTypewriter-Bold"]
        Chalkboard SE ["ChalkboardSE-Light", "ChalkboardSE-Regular", "ChalkboardSE-Bold"]
        Avenir Next ["AvenirNext-MediumItalic", "AvenirNext-Bold", "AvenirNext-UltraLight", "AvenirNext-DemiBold", "AvenirNext-HeavyItalic", "AvenirNext-Heavy", "AvenirNext-Medium", "AvenirNext-Italic", "AvenirNext-UltraLightItalic", "AvenirNext-BoldItalic", "AvenirNext-Regular", "AvenirNext-DemiBoldItalic"]
        Bangla Sangam MN is empty
        Noteworthy ["Noteworthy-Bold", "Noteworthy-Light"]
        Hiragino Sans ["HiraginoSans-W6", "HiraginoSans-W3"]
        Zapfino ["Zapfino"]
        Tamil Sangam MN ["TamilSangamMN", "TamilSangamMN-Bold"]
        Chalkduster ["Chalkduster"]
        Arial Hebrew ["ArialHebrew-Bold", "ArialHebrew-Light", "ArialHebrew"]
        Georgia ["Georgia-BoldItalic", "Georgia-Bold", "Georgia-Italic", "Georgia"]
        Helvetica Neue ["HelveticaNeue-BoldItalic", "HelveticaNeue-Light", "HelveticaNeue-Italic", "HelveticaNeue-UltraLightItalic", "HelveticaNeue-CondensedBold", "HelveticaNeue-MediumItalic", "HelveticaNeue-Thin", "HelveticaNeue-Medium", "HelveticaNeue-ThinItalic", "HelveticaNeue-UltraLight", "HelveticaNeue-LightItalic", "HelveticaNeue-Bold", "HelveticaNeue", "HelveticaNeue-CondensedBlack"]
        Gill Sans ["GillSans", "GillSans-SemiBoldItalic", "GillSans-Italic", "GillSans-BoldItalic", "GillSans-Light", "GillSans-LightItalic", "GillSans-UltraBold", "GillSans-Bold", "GillSans-SemiBold"]
        Kohinoor Devanagari ["KohinoorDevanagari-Regular", "KohinoorDevanagari-Light", "KohinoorDevanagari-Semibold"]
        Palatino ["Palatino-Roman", "Palatino-Italic", "Palatino-Bold", "Palatino-BoldItalic"]
        Courier New ["CourierNewPSMT", "CourierNewPS-BoldMT", "CourierNewPS-ItalicMT", "CourierNewPS-BoldItalicMT"]
        Oriya Sangam MN ["OriyaSangamMN", "OriyaSangamMN-Bold"]
        Didot ["Didot-Bold", "Didot-Italic", "Didot"]
        PingFang TC ["PingFangTC-Regular", "PingFangTC-Semibold", "PingFangTC-Medium", "PingFangTC-Thin", "PingFangTC-Ultralight", "PingFangTC-Light"]
        Bodoni 72 Smallcaps ["BodoniSvtyTwoSCITCTT-Book"]

*/
        
    }
    
    func doDynamicType(n:NSNotification) {
        let style = self.lab.font.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as! String
        self.lab.font = UIFont.preferredFontForTextStyle(style)
    }
    
    
}
