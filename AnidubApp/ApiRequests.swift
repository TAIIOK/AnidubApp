import Foundation
import Firebase

func add_device(Device_id: String, User_id: String, Remove: Int) {
    var request = URLRequest(url: URL(string: "http://taiiok.online/user_device.php")!)
    request.httpMethod = "POST"
    let bodyData = "Device_id=\(Device_id)&User_id=\(User_id)&Remove=\(Remove)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
         //  print(data)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    task.resume()
}

func get_video(VideoUrl: String) -> String {
    var result_string = ""
    var request = URLRequest(url: URL(string: "http://taiiok.online/player.php")!)
    request.httpMethod = "POST"
    let bodyData = "url=\(VideoUrl)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {
                var values  = convertedJsonIntoDict as? [String: Any]
                result_string = values?.first?.value as! String
                print(result_string)
            }
             semaphore.signal()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    task.resume()

    _ = semaphore.wait(timeout: .distantFuture)

    return result_string
}

func add_user(User_id: String) {
    var request = URLRequest(url: URL(string: "http://taiiok.online/user.php")!)
    request.httpMethod = "POST"
    let bodyData = "User_id=\(User_id)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
         //   print(data)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    task.resume()
}

func add_fav_new(User_id: String, Title_id: String, Remove: Int, is_anilibria: Int) {
    var request = URLRequest(url: URL(string: "http://taiiok.online/edit_fav.php")!)
    request.httpMethod = "POST"
    var bodyData = ""
    if(is_anilibria == 1) {
     bodyData = "User_id=\(User_id)&Title_id=\(Title_id)&Remove=\(Remove)&is_anilibria=\(is_anilibria)"
    } else {
     bodyData = "User_id=\(User_id)&Title_id=\(Int(Title_id)!)&Remove=\(Remove)&is_anilibria=\(is_anilibria)"
    }
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
         //   print(data)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    task.resume()
}

func edit_episodes_new(User_id: String, Title_id: Int, Episode: String, Remove: Int) {
    var request = URLRequest(url: URL(string: "http://taiiok.online/edit_episodes.php")!)
    request.httpMethod = "POST"
    let bodyData = "User_id=\(User_id)&Title_id=\(Title_id)&Episode=\(Episode)&Remove=\(Remove)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
          //  print(data)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    task.resume()
}

func get_episodes_new(User_id: String, Title_id: Int) -> [String] {
    var result = [String]()
    var request = URLRequest(url: URL(string: "http://taiiok.online/get_episodes.php")!)
    request.httpMethod = "POST"
    let bodyData = "User_id=\(User_id)&Title_id=\(Title_id)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {

               // print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                for case let temp_episode in Data! {
                    var episode  = temp_episode as? [String: Any]
                    result.append(episode!["Episode"] as! String)
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

    return result
}

func get_news_list(page: Int) -> [News] {
    var result = [News]()
    var request = URLRequest(url: URL(string: "http://taiiok.online/get_news_list.php?page=\(page)")!)
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {
                
                // print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                    for case let temp_fav in Data! {
                        let news  = temp_fav as? [String: Any]
                        result.append(News(description: news!["description"]! as! String, image: news!["image"]! as! String, Title: news!["title"]! as! String, Category: news!["category"]! as! String, Url: news!["url"]! as! String))
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
    
    return result
}



func get_fav_new(User_id: String) -> [fullTitle] {
    var result = [fullTitle]()
    var request = URLRequest(url: URL(string: "http://taiiok.online/get_fav.php")!)
    request.httpMethod = "POST"
    let bodyData = "User_id=\(User_id)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {

              //  print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                    for case let temp_fav in Data! {
                        var fav  = temp_fav as? [String: Any]
                        result.append(fullTitle(ID: Int(fav!["Title_id"] as! String)!, Url: fav!["Poster"]! as! String, Title: Title(fullName: fav!["Title"]! as! String, Russian: fav!["Title"]! as! String, Original: "", Episodes: ""), Uploader: "", Categories: [""], Poster: fav!["Poster"]! as! String, Information: Information(Year: "", Genres: fav!["Genres"]! as! String, Country: fav!["Country"]! as! String, Episodes: "", Release: fav!["Release"]! as! String, Director: "", Author: "", Dubbers: fav!["Dubbers"]! as! String, Translators: "", Studio: fav!["Studio"]! as! String, Description: fav!["Information"]! as! String), Commentaries: 0, Rating: Rating(RType: 0, Grade: fav!["Rating"]! as! String, Votes: "")))

                    }
                    result.reverse()
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

func get_title_anilibria(page: Int) -> [fullTitle] {
    var result = [fullTitle]()
    var request = URLRequest(url: URL(string: "http://taiiok.online/get_anilibria_list.php")!)
    request.httpMethod = "POST"
    let bodyData = "Page=\(page)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {

                //  print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                    for case let temp_fav in Data! {
                        var fav  = temp_fav as? [String: Any]
                        result.append(fullTitle(ID: fav!["ID"] as! Int, Url: fav!["TitleUrl"]! as! String, Title: Title(fullName: fav!["TitleName"]! as! String, Russian: fav!["TitleName"]! as! String, Original: "", Episodes: fav!["Episodes"]! as! String), Uploader: "", Categories: [""], Poster: fav!["Poster"]! as! String, Information: Information(Year: "", Genres: "", Country: "", Episodes: fav!["Episodes"]! as! String, Release: "", Director: "", Author: "", Dubbers: "", Translators: "", Studio: "", Description: ""), Commentaries: 0, Rating: Rating(RType: 0, Grade: "0", Votes: "")))

                    }
                    result.reverse()
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

func get_currenttitle_anilibria(url: String) -> [fullTitle] {
    var result = [fullTitle]()

    var request = URLRequest(url: URL(string: "http://taiiok.online/get_anilibria_title.php?Url=\(url)")!)

    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {

                //  print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                    for case let temp_fav in Data! {
                        var fav  = temp_fav as? [String: Any]
                        result.append(fullTitle(ID: -1, Url: fav!["PlayerUrl"]! as! String, Title: Title(fullName: "", Russian: "", Original: "", Episodes: ""), Uploader: "", Categories: [""], Poster: "", Information: Information(Year: "", Genres: fav!["Genres"]! as! String, Country: "", Episodes: "", Release: "", Director: "", Author: "", Dubbers: fav!["Dubbers"]! as! String, Translators: "", Studio: "", Description: fav!["Description"]! as! String), Commentaries: 0, Rating: Rating(RType: 0, Grade: "", Votes: "")))

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

    return result

}

func search_anilibria(mytitle: String) -> [fullTitle] {
    var result = [fullTitle]()

    let request = URLRequest(url: URL(string: "http://taiiok.online/search_title_anilibria.php?Title=\(mytitle)".encodeUrl)!)

    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        do {
            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) {

                //  print(convertedJsonIntoDict)
                let Data = convertedJsonIntoDict as?  Array<Any>
                if(Data != nil) {
                    for case let temp_fav in Data! {
                        var fav  = temp_fav as? [String: Any]
                        result.append(fullTitle(ID: -1, Url: fav!["TitleUrl"]! as! String, Title: Title(fullName: fav!["TitleName"]! as! String, Russian: fav!["TitleName"]! as! String, Original: fav!["TitleName"]! as! String, Episodes: fav!["Episodes"]! as! String), Uploader: "", Categories: [""], Poster: fav!["Poster"]! as! String, Information: Information(Year: "", Genres: "", Country: "", Episodes: fav!["Episodes"]! as! String, Release: "", Director: "", Author: "", Dubbers: "", Translators: "", Studio: "", Description: ""), Commentaries: 0, Rating: Rating(RType: 0, Grade: "", Votes: "")))

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

    return result

}

func add_fav(ID: Int, login: Int, password: String, userHash: String) -> Bool {

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/fav.Add")!)
    request.httpMethod = "POST"

    var bodyData = "id=\(ID)&user_id=\(login)&user_password=\(password)&user_hash=\(userHash)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]

                if ((Response?["Data"] as? String)! == "Added") {
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
func remove_fav(ID: Int, login: Int, password: String, userHash: String) -> Bool {
    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/fav.Delete")!)
    request.httpMethod = "POST"

    var bodyData = "id=\(ID)&user_id=\(login)&user_password=\(password)&user_hash=\(userHash)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                print(Response)
                if ((Response?["Data"] as? String)! == "Removed") {
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

func is_fav(ID: Int, login: Int, password: String, userHash: String) -> Bool {
    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/fav.Check")!)
    request.httpMethod = "POST"

    var bodyData = "id=\(ID)&user_id=\(login)&user_password=\(password)&user_hash=\(userHash)"
    var result = false
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
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

func get_fav_count(login: Int, password: String, userHash: String) -> Int {
    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/fav.getCount")!)
    request.httpMethod = "POST"

    var bodyData = "user_id=\(login)&user_password=\(password)&user_hash=\(userHash)"
    var result = false
    var Count = 0
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
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

func User_login(login: String, password: String) -> user? {

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/account.doAuth")!)
    request.httpMethod = "POST"

    var bodyData = "login=\(login)&password=\(md5(password))"
    var result = false
    var ID = 0
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]

                result = convertedJsonIntoDict?["Error"] as! Bool
                if(!result) {
                let Data = Response?["Data"] as?  [String: Any]

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

    if(result == true) {
        return nil
    }

    print(ID)
    return user(ID: ID, favCount: get_fav_count(login: ID, password: md5(password), userHash: "someHash"), username: login, password: md5(password) )
}

func setupRating(data: [String: Any]) -> Rating? {

    var inputTitle = data["Rating"] as? [String: Any]

    guard let rtype = inputTitle?["Type"] as? Int,
        let grade = inputTitle?["Grade"] as? String,
        let votes = inputTitle?["Votes"] as? String
        else {
            return nil
    }

    return Rating(RType: rtype, Grade: grade, Votes: votes)

}

func setupInformation(data: [String: Any]) -> Information? {
    var inputInformation = data["Information"] as? [String: Any]

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
    if(studio == nil) {
        studio = "Неизвестно"
    }

    return Information(Year: year, Genres: genres, Country: country, Episodes: episodes, Release: release, Director: director, Author: author, Dubbers: dubbers, Translators: translators, Studio: studio!, Description: description)

}

func setupTitle(data: [String: Any]) -> Title? {
    var inputTitle = data["Title"] as? [String: Any]

    let full = inputTitle?["Full"] as? String
    var episodes = inputTitle?["Episodes"] as? String
    if(episodes == nil) {
        episodes = ""
    }

    return Title(fullName: full!, Russian: full!, Original: "", Episodes: episodes!)

}

func setupFullTitle(data: [String: Any]) -> fullTitle? {

    let title = setupTitle(data: data)
    let information = setupInformation(data: data)
    let rating = setupRating(data: data)

    var result: fullTitle

    if(data["ID"] as? String == nil) {

        guard let id = data["Id"] as? String,
            let url = data["Url"] as? String,
            let uploader = data["Uploader"] as? String,
            let categories = data["Categories"] as? [String],
            let poster = data["Poster"] as? String,
            let commentaries = data["Commentaries"] as? String
            else {
                return nil
        }
        if(categories.count > 0) {
        if((categories.first?.contains("Новости проекта"))!) {
            return nil
        }
        }
        if (id == nil || url == nil || title == nil || uploader == nil || categories == nil || poster == nil || information == nil || rating == nil) {
            return nil
        }
        result  = fullTitle(ID: Int(id)!, Url: url, Title: title!, Uploader: uploader, Categories: categories, Poster: poster, Information: information!, Commentaries: 0, Rating: rating!)
    } else {

    guard let id = data["ID"] as? String,
        let url = data["Url"] as? String,
        let uploader = data["Uploader"] as? String,
        let categories = data["Categories"] as? [String],
        let poster = data["Poster"] as? String,
        var commentaries = data["Commentaries"] as? String
        else {
            return nil
        }
        if(commentaries == "") {
            commentaries = "0"
        }
        if(categories.count > 0) {
            if((categories.first?.contains("Новости проекта"))!) {
                return nil
            }
        }
        if (id == nil || url == nil || title == nil || uploader == nil || categories == nil || poster == nil || information == nil || rating == nil) {
            return nil
        }
        result  = fullTitle(ID: Int(id)!, Url: url, Title: title!, Uploader: uploader, Categories: categories, Poster: poster, Information: information!, Commentaries: 0, Rating: rating!)
    }

        return result

}

func setupEpisodes(data: [String: Any]) -> [[episodes]]? {
    var result = [[episodes]]()
    var episodlist = [episodes]()

    var mirrorarray = data["Mirror"] as! Array<Any>
    for case let result in mirrorarray {
        var elem = result as? [String: Any]
        var string = elem?["Name"] as! String
        if var substring = string.components(separatedBy: "-").last { // Unwrap the optional

            var temp: String = elem?["Url"] as! String
            let index = temp.index(of: " ") ?? temp.endIndex
            let beginning = temp[..<index]

            if(!String(beginning).contains("http")) {

                temp = "https:" + String(beginning)
                print(temp)
            } else {
                if(temp.contains(" ")) {
                temp = String(String(beginning).dropLast(1))
                }
            }

            episodlist.append(episodes(Name: substring, Url: temp))
        }

    }
    result.append(episodlist)
    episodlist.removeAll()

    mirrorarray = data["Anidub"] as! Array<Any>
    for case let result in mirrorarray {
        var elem = result as? [String: Any]
        var string = elem?["Name"] as! String
        if var substring = string.components(separatedBy: "-").last { // Unwrap the optional
            var temp = elem?["Url"] as! String

            episodlist.append(episodes(Name: substring, Url: temp))
        }
    }
    result.append(episodlist)
    return result

}
func search_string(name: String, page: Int) -> [fullTitle] {

    var Titles_list = [fullTitle]()

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v5/anime.search?")!)
    request.httpMethod = "POST"
    var bodyData = "query=\(name)&page=\(page)"
    var result = false

    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>

                for case let result in Data! {

                    let title = setupFullTitle(data: result as! [String: Any])
                    if(title != nil) {
                    Titles_list.append(title!)
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

func getTitle_list(page: Int) -> [fullTitle] {

    var Titles_list = [fullTitle]()

    // url http://anidub-api.herokuapp.com/method/titles.list

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v5/anime.getList")!)
    request.httpMethod = "POST"
    var bodyData = "page=\(page)"
    var result = false

    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>

                for case let result in Data! {

                 let title = setupFullTitle(data: result as! [String: Any])
                    if(title != nil) {
                    Titles_list.append(title!)
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

func == (lhs: fullTitle, rhs: fullTitle) -> Bool {
    return lhs.Categories == rhs.Categories && lhs.Url == rhs.Url && lhs.ID == rhs.ID
}

func getFav_list(login: Int, password: String, page: Int) -> [fullTitle] {

    var Titles_list = [fullTitle]()

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v4/fav.getAll")!)
    request.httpMethod = "POST"
    var bodyData = "user_id=\(login)&user_password=\(password)&page=\(page)"
    var result = false

    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  Array<Any>
                if(Data != nil) {
                for case let result in Data! {

                let title = setupFullTitle(data: result as! [String: Any])
                    var  index =  Titles_list.index { $0.Title.Russian  == title?.Title.Russian  }
                    if(index == nil) {
                        Titles_list.append(title!)
                    }

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

func getTitles_episodes(id: Int) -> [[episodes]] {

    var listEpisodes = [[episodes]]()

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v5/anime.getEpisodes")!)
    request.httpMethod = "POST"
    var bodyData = "id=\(id)"
    var result = false

    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                let Response = convertedJsonIntoDict?["Response"] as? [String: Any]
                let Data = Response?["Data"] as?  [String: Any]

                if(Data != nil) {
               listEpisodes = setupEpisodes(data: Data!)!
                }
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

func get_Title(id: Int) -> [fullTitle] {

    var Titles_list = [fullTitle]()

    var request = URLRequest(url: URL(string: "http://api.anidub-app.ru/v5/anime.getInfo?id=\(id)")!)

    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }

        do {

            if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {

                let Response = convertedJsonIntoDict["Response"] as? [String: Any]

                let title = setupFullTitle(data: Response!)

                Titles_list.append(title!)

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

func get_favorites(u_id: String, completion: @escaping (_ result: [fullTitle]) -> Void) {

    var result = [fullTitle]()
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        let value = snapshot.value as? NSDictionary
        let bookmark = value?["bookmarks"] as? [String: AnyObject] ?? [:]

        if (bookmark.count == 0) {
            return
        }
        for item in bookmark {
            print(item.key)

            if  let value = item.value as? [String: String] {

                if(value["Rating"] == nil || (!(value["Title"]?.contains("из"))! && !(value["Title"]?.contains("Movie"))!)) {
                   let title =  get_Title(id: Int(item.key)!)
                    result.append(title.first!)
                    update_favorites(title: title.first!, update: true)
                } else {
                      result.append(fullTitle(ID: Int(item.key)!, Url: value["Image"]!, Title: Title(fullName: value["Title"]!, Russian: value["Title"]!, Original: "", Episodes: ""), Uploader: "", Categories: [""], Poster: value["Image"]!, Information: Information(Year: "", Genres: value["Genres"]!, Country: value["Country"]!, Episodes: "", Release: "", Director: "", Author: "", Dubbers: value["Dubbers"]!, Translators: "", Studio: value["Studio"]!, Description: value["Description"]!), Commentaries: 0, Rating: Rating(RType: 0, Grade: value["Rating"]!, Votes: "")))
                }
            } else {
                    continue
            }
        }
        // ...
        completion(result)
    }) { (error) in
        print(error.localizedDescription)
    }

}
func update_favorites(title: fullTitle, update: Bool) {

    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    if(userID != nil) {
        if(update) {
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Country").setValue(title.Information.Country)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Description").setValue(title.Information.Description)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Dubbers").setValue(title.Information.Dubbers)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Image").setValue(title.Poster)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Studio").setValue(title.Information.Studio)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Title").setValue(title.Title.fullName)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Genres").setValue(title.Information.Genres)
    ref.child("users/\(userID!)/bookmarks/\(title.ID)/Rating").setValue(title.Rating.Grade)
        } else {
            ref.child("users/\(userID!)/bookmarks/\(title.ID)").removeValue()
        }
    }
}
func get_recent(u_id: String, completion: @escaping (_ result: [fullTitle]) -> Void) {

    var result = [fullTitle]()
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        let value = snapshot.value as? NSDictionary
        let recent = value?["recent"] as? [String: AnyObject] ?? [:]

        if (recent.count == 0) {
            return
        }
        if(recent.count > 20) {

            ref.child("users/\(userID!)/recent/\(recent.dropLast().first?.key)").removeValue()

        }
        for item in recent {
            print(item.key)

            if  let value = item.value as? [String: String] {

                if(value["Rating"] == nil || (!(value["Title"]?.contains("из"))! && !(value["Title"]?.contains("Movie"))!)) {

                        let title =  get_Title(id: Int(item.key)!)
                        result.append(title.first!)
                        update_recent(title: title.first!, update: true)

                } else {
                result.append(fullTitle(ID: Int(item.key)!, Url: value["Image"]!, Title: Title(fullName: value["Title"]!, Russian: value["Title"]!, Original: "", Episodes: ""), Uploader: "", Categories: [""], Poster: value["Image"]!, Information: Information(Year: "", Genres: value["Genres"]!, Country: value["Country"]!, Episodes: "", Release: "", Director: "", Author: "", Dubbers: value["Dubbers"]!, Translators: "", Studio: value["Studio"]!, Description: value["Description"]!), Commentaries: 0, Rating: Rating(RType: 0, Grade: value["Rating"]!, Votes: "")))
                }
            } else {
                continue
            }
        }

        // ...
        completion(result)
    }) { (error) in
        print(error.localizedDescription)
    }
}

func get_episodes(id: Int, completion: @escaping (_ result: [[Int]]) -> Void) {

    var result = [[Int]]()
    var first = [Int]()
    var second = [Int]()
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    ref.child("users").child(userID!).child("episodes").child(String(id)).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        let value = snapshot.value as? NSDictionary
        if let alt_list = (value?["alt"] as?  NSMutableArray) {
            for item in alt_list {
            if(item is Int) {
            first.append(item as! Int)
            }
        }
        }
        if let anidub = (value?["anidub"] as?  NSMutableArray) {
            for item in anidub {
            if(item is Int) {
            second.append(item as! Int)
            }
        }
        }

        if let alt_list = (value?["alt"] as?  NSMutableDictionary) {
            for item in alt_list {
                 if(item.value is Int) {
                first.append(item.value as! Int)
                }
            }
        }

        if let anidub = (value?["anidub"] as?  NSMutableDictionary) {
            for item in anidub {
                if(item.value is Int) {
                second.append(item.value as! Int)
                }
            }
        }

        result.append(first)
        result.append(second)

        completion(result)
    }) { (error) in
        print(error.localizedDescription)
    }
}

func update_episodes(id: Int, episode: Int, alt: Bool, update: Bool) {

    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    if(userID != nil) {
        if(alt) {
        if(update) {
            ref.child("users/\(userID!)/episodes/\(id)/alt/\(episode)").setValue(episode)
        } else {
            ref.child("users/\(userID!)/episodes/\(id)/alt/\(episode)").removeValue()
        }
        } else {
            if(update) {
                ref.child("users/\(userID!)/episodes/\(id)/anidub/\(episode)").setValue(episode)
            } else {
                ref.child("users/\(userID!)/episodes/\(id)/anidub/\(episode)").removeValue()
            }
        }
    }
}

func update_recent(title: fullTitle, update: Bool) {

    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.keepSynced(true)
    let userID = Auth.auth().currentUser?.uid

    if(userID != nil) {
        if(update) {
            ref.child("users/\(userID!)/recent/\(title.ID)/Country").setValue(title.Information.Country)
            ref.child("users/\(userID!)/recent/\(title.ID)/Description").setValue(title.Information.Description)
            ref.child("users/\(userID!)/recent/\(title.ID)/Dubbers").setValue(title.Information.Dubbers)
            ref.child("users/\(userID!)/recent/\(title.ID)/Image").setValue(title.Poster)
            ref.child("users/\(userID!)/recent/\(title.ID)/Studio").setValue(title.Information.Studio)
            ref.child("users/\(userID!)/recent/\(title.ID)/Title").setValue(title.Title.fullName)
            ref.child("users/\(userID!)/recent/\(title.ID)/Genres").setValue(title.Information.Genres)
            ref.child("users/\(userID!)/recent/\(title.ID)/Rating").setValue(title.Rating.Grade)
        } else {
            ref.child("users/\(userID!)/recent/\(title.ID)").removeValue()
        }
    }
}

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
}
