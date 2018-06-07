import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        // this is the book code
        
        UIFont.familyNames.forEach {
            UIFont.fontNames(forFamilyName:$0).forEach {print($0)}}
        
        // to be honest, I'd rather see it this way
        
        UIFont.familyNames.sorted().forEach { name in
            print(name, UIFont.fontNames(forFamilyName:name))
        }


        // what explains the empty families? they are aliases
        // for example, family "Heiti TC" is actually another name for "PingFangTC-Light"
        
        /*
         
         Academy Engraved LET ["AcademyEngravedLetPlain"]
         Al Nile ["AlNile", "AlNile-Bold"]
         American Typewriter ["AmericanTypewriter-CondensedBold", "AmericanTypewriter-Condensed", "AmericanTypewriter-CondensedLight", "AmericanTypewriter", "AmericanTypewriter-Bold", "AmericanTypewriter-Semibold", "AmericanTypewriter-Light"]
         Apple Color Emoji ["AppleColorEmoji"]
         Apple SD Gothic Neo ["AppleSDGothicNeo-Thin", "AppleSDGothicNeo-Light", "AppleSDGothicNeo-Regular", "AppleSDGothicNeo-Bold", "AppleSDGothicNeo-SemiBold", "AppleSDGothicNeo-UltraLight", "AppleSDGothicNeo-Medium"]
         Arial ["Arial-BoldMT", "Arial-BoldItalicMT", "Arial-ItalicMT", "ArialMT"]
         Arial Hebrew ["ArialHebrew-Bold", "ArialHebrew-Light", "ArialHebrew"]
         Arial Rounded MT Bold ["ArialRoundedMTBold"]
         Avenir ["Avenir-Oblique", "Avenir-HeavyOblique", "Avenir-Heavy", "Avenir-BlackOblique", "Avenir-BookOblique", "Avenir-Roman", "Avenir-Medium", "Avenir-Black", "Avenir-Light", "Avenir-MediumOblique", "Avenir-Book", "Avenir-LightOblique"]
         Avenir Next ["AvenirNext-Medium", "AvenirNext-DemiBoldItalic", "AvenirNext-DemiBold", "AvenirNext-HeavyItalic", "AvenirNext-Regular", "AvenirNext-Italic", "AvenirNext-MediumItalic", "AvenirNext-UltraLightItalic", "AvenirNext-BoldItalic", "AvenirNext-Heavy", "AvenirNext-Bold", "AvenirNext-UltraLight"]
         Avenir Next Condensed ["AvenirNextCondensed-Heavy", "AvenirNextCondensed-MediumItalic", "AvenirNextCondensed-Regular", "AvenirNextCondensed-UltraLightItalic", "AvenirNextCondensed-Medium", "AvenirNextCondensed-HeavyItalic", "AvenirNextCondensed-DemiBoldItalic", "AvenirNextCondensed-Bold", "AvenirNextCondensed-DemiBold", "AvenirNextCondensed-BoldItalic", "AvenirNextCondensed-Italic", "AvenirNextCondensed-UltraLight"]
         Bangla Sangam MN []
         Baskerville ["Baskerville-SemiBoldItalic", "Baskerville-SemiBold", "Baskerville-BoldItalic", "Baskerville", "Baskerville-Bold", "Baskerville-Italic"]
         Bodoni 72 ["BodoniSvtyTwoITCTT-Bold", "BodoniSvtyTwoITCTT-BookIta", "BodoniSvtyTwoITCTT-Book"]
         Bodoni 72 Oldstyle ["BodoniSvtyTwoOSITCTT-BookIt", "BodoniSvtyTwoOSITCTT-Book", "BodoniSvtyTwoOSITCTT-Bold"]
         Bodoni 72 Smallcaps ["BodoniSvtyTwoSCITCTT-Book"]
         Bodoni Ornaments ["BodoniOrnamentsITCTT"]
         Bradley Hand ["BradleyHandITCTT-Bold"]
         Chalkboard SE ["ChalkboardSE-Bold", "ChalkboardSE-Light", "ChalkboardSE-Regular"]
         Chalkduster ["Chalkduster"]
         Cochin ["Cochin-Italic", "Cochin-Bold", "Cochin", "Cochin-BoldItalic"]
         Copperplate ["Copperplate-Light", "Copperplate", "Copperplate-Bold"]
         Courier ["Courier-BoldOblique", "Courier-Oblique", "Courier", "Courier-Bold"]
         Courier New ["CourierNewPS-ItalicMT", "CourierNewPSMT", "CourierNewPS-BoldItalicMT", "CourierNewPS-BoldMT"]
         Damascus ["DamascusBold", "DamascusLight", "Damascus", "DamascusMedium", "DamascusSemiBold"]
         Devanagari Sangam MN ["DevanagariSangamMN", "DevanagariSangamMN-Bold"]
         Didot ["Didot-Bold", "Didot", "Didot-Italic"]
         Euphemia UCAS ["EuphemiaUCAS", "EuphemiaUCAS-Italic", "EuphemiaUCAS-Bold"]
         Farah ["Farah"]
         Futura ["Futura-CondensedExtraBold", "Futura-Medium", "Futura-Bold", "Futura-CondensedMedium", "Futura-MediumItalic"]
         Geeza Pro ["GeezaPro-Bold", "GeezaPro"]
         Georgia ["Georgia-BoldItalic", "Georgia-Italic", "Georgia", "Georgia-Bold"]
         Gill Sans ["GillSans-Italic", "GillSans-SemiBold", "GillSans-UltraBold", "GillSans-Light", "GillSans-Bold", "GillSans", "GillSans-SemiBoldItalic", "GillSans-BoldItalic", "GillSans-LightItalic"]
         Gujarati Sangam MN ["GujaratiSangamMN", "GujaratiSangamMN-Bold"]
         Gurmukhi MN ["GurmukhiMN-Bold", "GurmukhiMN"]
         Heiti SC []
         Heiti TC []
         Helvetica ["Helvetica-Oblique", "Helvetica-BoldOblique", "Helvetica", "Helvetica-Light", "Helvetica-Bold", "Helvetica-LightOblique"]
         Helvetica Neue ["HelveticaNeue-UltraLightItalic", "HelveticaNeue-Medium", "HelveticaNeue-MediumItalic", "HelveticaNeue-UltraLight", "HelveticaNeue-Italic", "HelveticaNeue-Light", "HelveticaNeue-ThinItalic", "HelveticaNeue-LightItalic", "HelveticaNeue-Bold", "HelveticaNeue-Thin", "HelveticaNeue-CondensedBlack", "HelveticaNeue", "HelveticaNeue-CondensedBold", "HelveticaNeue-BoldItalic"]
         Hiragino Maru Gothic ProN ["HiraMaruProN-W4"]
         Hiragino Mincho ProN ["HiraMinProN-W3", "HiraMinProN-W6"]
         Hiragino Sans ["HiraginoSans-W3", "HiraginoSans-W6"]
         Hoefler Text ["HoeflerText-Italic", "HoeflerText-Black", "HoeflerText-Regular", "HoeflerText-BlackItalic"]
         Kailasa ["Kailasa-Bold", "Kailasa"]
         Kannada Sangam MN ["KannadaSangamMN-Bold", "KannadaSangamMN"]
         Kefa ["Kefa-Regular"]
         Khmer Sangam MN ["KhmerSangamMN"]
         Kohinoor Bangla ["KohinoorBangla-Regular", "KohinoorBangla-Semibold", "KohinoorBangla-Light"]
         Kohinoor Devanagari ["KohinoorDevanagari-Regular", "KohinoorDevanagari-Light", "KohinoorDevanagari-Semibold"]
         Kohinoor Telugu ["KohinoorTelugu-Regular", "KohinoorTelugu-Medium", "KohinoorTelugu-Light"]
         Lao Sangam MN ["LaoSangamMN"]
         Malayalam Sangam MN ["MalayalamSangamMN-Bold", "MalayalamSangamMN"]
         Marker Felt ["MarkerFelt-Thin", "MarkerFelt-Wide"]
         Menlo ["Menlo-BoldItalic", "Menlo-Bold", "Menlo-Italic", "Menlo-Regular"]
         Mishafi ["DiwanMishafi"]
         Myanmar Sangam MN ["MyanmarSangamMN", "MyanmarSangamMN-Bold"]
         Noteworthy ["Noteworthy-Bold", "Noteworthy-Light"]
         Noto Nastaliq Urdu ["NotoNastaliqUrdu"]
         Optima ["Optima-ExtraBlack", "Optima-BoldItalic", "Optima-Italic", "Optima-Regular", "Optima-Bold"]
         Oriya Sangam MN ["OriyaSangamMN", "OriyaSangamMN-Bold"]
         Palatino ["Palatino-Italic", "Palatino-Roman", "Palatino-BoldItalic", "Palatino-Bold"]
         Papyrus ["Papyrus-Condensed", "Papyrus"]
         Party LET ["PartyLetPlain"]
         PingFang HK ["PingFangHK-Medium", "PingFangHK-Thin", "PingFangHK-Regular", "PingFangHK-Ultralight", "PingFangHK-Semibold", "PingFangHK-Light"]
         PingFang SC ["PingFangSC-Medium", "PingFangSC-Semibold", "PingFangSC-Light", "PingFangSC-Ultralight", "PingFangSC-Regular", "PingFangSC-Thin"]
         PingFang TC ["PingFangTC-Regular", "PingFangTC-Thin", "PingFangTC-Medium", "PingFangTC-Semibold", "PingFangTC-Light", "PingFangTC-Ultralight"]
         Savoye LET ["SavoyeLetPlain"]
         Sinhala Sangam MN ["SinhalaSangamMN-Bold", "SinhalaSangamMN"]
         Snell Roundhand ["SnellRoundhand", "SnellRoundhand-Bold", "SnellRoundhand-Black"]
         Symbol ["Symbol"]
         Tamil Sangam MN ["TamilSangamMN", "TamilSangamMN-Bold"]
         Telugu Sangam MN []
         Thonburi ["Thonburi", "Thonburi-Light", "Thonburi-Bold"]
         Times New Roman ["TimesNewRomanPS-ItalicMT", "TimesNewRomanPS-BoldItalicMT", "TimesNewRomanPS-BoldMT", "TimesNewRomanPSMT"]
         Trebuchet MS ["TrebuchetMS-Bold", "TrebuchetMS-Italic", "Trebuchet-BoldItalic", "TrebuchetMS"]
         Verdana ["Verdana-Italic", "Verdana", "Verdana-Bold", "Verdana-BoldItalic"]
         Zapf Dingbats ["ZapfDingbatsITC"]
         Zapfino ["Zapfino"]

         */

        
        return true
    }
}
