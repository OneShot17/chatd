typealias Printable = CustomStringConvertible

public class FormattedString : Printable {
    
    public var description: String {
        get {
            return foregroundColor.rawValue + string + ShellColor.Default.rawValue;
        }
    }
    
    let foregroundColor: ShellColor;
    let string: String;
    
    public init (_ string: String, color foreground: ShellColor) {
        foregroundColor = foreground;
        self.string = string;
    }
    
    public convenience init (_ string: String) {
        self.init(string, color: ShellColor.Default);
    }
}
