import Foundation

func add_fav(ID:Int,login:Int,password:String) -> Bool {
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/fav.add")!)
    request.httpMethod = "POST"
    
    var bodyData = "id=\(ID)&user_id=\(login)&password=\(password)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                
                if ((Response?["Data"] as? String)! == "Added")
                {
                    result = true
                }
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return result
    
}
func remove_fav(ID:Int,login:Int,password:String) -> Bool {
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/fav.delete")!)
    request.httpMethod = "POST"
    
    var bodyData = "id=\(ID)&user_id=\(login)&password=\(password)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                print(Response)
                if ((Response?["Data"] as? String)! == "Removed")
                {
                    result = true
                }
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return result
    
}

func is_fav(ID:Int,login:Int,password:String) -> Bool {
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/fav.isFav")!)
    request.httpMethod = "POST"
    
    var bodyData = "id=\(ID)&user_id=\(login)&password=\(password)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]

                result  =  (Response?["Data"] as? Bool)!
    
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return result
    
}





func get_fav_count(login:Int,password:String) -> Int {
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/fav.count")!)
    request.httpMethod = "POST"
    
    var bodyData = "user_id=\(login)&password=\(password)"
    var result = false
    var Count = 0
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]

                
                var string =  (Response?["Data"] as? String)!
                
                print(string)
                
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return Count

}


func User_login(login:String,password:String) -> user? {
    
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/account.login")!)
    request.httpMethod = "POST"
    
    var bodyData = "login=\(login)&password=\(md5(password))"
    var result = false
    var ID = 0
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                

                result = convertedJsonIntoDict?["Error"] as! Bool
                if(!result){
                let Data = Response?["Data"] as?  [String:Any]
                
                ID =  Int(Data?["ID"] as! String)!
                }
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    if(result == true)
    {
        return nil
    }
    
    print(ID)
    return user(ID: ID, favCount: get_fav_count(login: ID, password: md5(password)), username: login , password: md5(password) )
}



func setupRating(data: [String:Any]) -> Rating?{

    var inputTitle = data["Rating"] as? [String:Any]
    
    guard let rtype = inputTitle?["Type"] as? Int,
        let grade = inputTitle?["Grade"] as? String,
        let votes = inputTitle?["Votes"] as? String
        else {
            return nil
    }
    
    return Rating(RType: rtype, Grade: grade, Votes: votes)

}

func setupInformation(data: [String:Any]) -> Information?{
    var inputInformation = data["Information"] as? [String:Any]
    
    guard let year = inputInformation?["Year"] as? String,
        let genres = inputInformation?["Genres"] as? String,
        let country = inputInformation?["Country"] as? String,
        let episodes = inputInformation?["Episodes"] as? String,
        let release = inputInformation?["Release"] as? String,
        let director = inputInformation?["Director"] as? String,
        let author = inputInformation?["Author"] as? String,
        let dubbers = inputInformation?["Dubbers"] as? String,
        let translators = inputInformation?["Translators"] as? String,
        let description = inputInformation?["Description"] as? String,
        var studio = inputInformation?["Studio"] as? String?
        
        else {
        
            return nil
        }
    if(studio == nil)
    {
        studio = "Неизвестно"
    }
    
    return Information(Year: year, Genres: genres, Country: country, Episodes: episodes, Release: release, Director: director, Author: author, Dubbers: dubbers, Translators: translators, Studio: studio!, Description: description)
    
    
}


func setupTitle(data: [String:Any]) -> Title?
{
    var inputTitle = data["Title"] as? [String:Any]
    
    
    
    
    guard let full = inputTitle?["Full"] as? String,
        let russian = inputTitle?["Russian"] as? String,
        let original = inputTitle?["Original"] as? String,
        let episodes = inputTitle?["Episodes"] as? String
        else {
         return nil
        }
    
    return Title(fullName: full, Russian: russian, Original: original, Episodes: episodes)

}

func setupFullTitle(data: [String:Any]) -> fullTitle?
{
    
    let title = setupTitle(data: data)
    let information = setupInformation(data: data)
    let rating = setupRating(data: data)
    
    
    guard let id = data["ID"] as? String,
        let url = data["Url"] as? String,
        let uploader = data["Uploader"] as? String,
        let categories = data["Categories"] as? [String],
        let poster = data["Poster"] as? String,
        let commentaries = data["Commentaries"] as? String
        else {
            return nil
        }
    
    let result  = fullTitle(ID: Int(id)!, Url: url, Title: title!, Uploader: uploader, Categories: categories, Poster: poster, Information: information!, Commentaries: Int(commentaries)!, Rating: rating!)
    
        return result
    
}

func setupEpisodes(data: [String:Any]) -> [[episodes]]?{
    var result = [[episodes]]()
    var episodlist = [episodes]()
    
    var mirrorarray = data["Mirror"] as! Array<Any>
    for case let result in mirrorarray {
        var elem = result as? [String:Any]
        var string = elem?["Name"] as! String
        if var substring = string.components(separatedBy: "-").last { // Unwrap the optional
            episodlist.append(episodes(Name: substring, Url: elem?["Url"] as! String))
        }
        
        
    }
    result.append(episodlist)
    episodlist.removeAll()
    
    mirrorarray = data["Anidub"] as! Array<Any>
    for case let result in mirrorarray {
        var elem = result as? [String:Any]
        var string = elem?["Name"] as! String
        if var substring = string.components(separatedBy: "-").last { // Unwrap the optional
            episodlist.append(episodes(Name: substring, Url: elem?["Url"] as! String))
        }
    }
    result.append(episodlist)
    return result


}
func search_string(name: String, page:Int) -> [fullTitle]{
    
    var Titles_list = [fullTitle]()
    
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/titles.search")!)
    request.httpMethod = "POST"
    var bodyData = "query=\(name)&page=\(page)"
    var result = false
    
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>
                
                for case let result in Data! {
                    
                    Titles_list.append(setupFullTitle(data: result as! [String : Any])!)
                    
                }
    
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return Titles_list
    
}




func getTitle_list(page:Int) -> [fullTitle]{
    
    var Titles_list = [fullTitle]()
    
    // url http://anidub-api.herokuapp.com/method/titles.list
    
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/titles.list")!)
    request.httpMethod = "POST"
    var bodyData = "page=\(page)"
    var result = false
    
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>
                
                for case let result in Data! {
                    
                    Titles_list.append(setupFullTitle(data: result as! [String : Any])!)
                    
                }
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return Titles_list
    
}



func getFav_list(login:Int,password:String,page:Int) -> [fullTitle]{

    var Titles_list = [fullTitle]()
    
    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/fav.list")!)
    request.httpMethod = "POST"
    var bodyData = "user_id=\(login)&password=\(md5(password))&page=\(page)"
    var result = false
    
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>
                if(Data != nil){
                for case let result in Data! {
                
                  Titles_list.append(setupFullTitle(data: result as! [String : Any])!)
                
                }
                }
               
                
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return Titles_list

}

func getTitles_episodes(id:Int) -> [[episodes]] {

    var listEpisodes = [[episodes]]()


    var request = URLRequest(url: URL(string: "https://anidub-api.herokuapp.com/method/titles.getEpisodes")!)
    request.httpMethod = "POST"
    var bodyData = "id=\(id)"
    var result = false
    
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        do {
            
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                
                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  [String:Any]


               listEpisodes = setupEpisodes(data: Data!)!
   
            }
            semaphore.signal()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return listEpisodes
}
