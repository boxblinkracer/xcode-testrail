import Foundation

class IniParser
{
    
    private var content : String;

    init(content : String)
    {
        self.content = content;
    }

    func getValue(key: String) -> String
    {
        
        let lines = content.split(whereSeparator: \.isNewline)
        
        for line in lines {
           
            let regex = try! NSRegularExpression(pattern: "(" + key + "=)")

            let matches = regex.matches(in: String(line), range: NSMakeRange(0, line.count));

            if (matches.isEmpty) {
                continue;
            }
          
            let values = line.components(separatedBy: "=")
            let value = values[1];
            
            return value;
        }
        
        return "";
    }
    
}
