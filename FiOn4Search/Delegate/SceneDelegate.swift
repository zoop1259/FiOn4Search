//
//  SceneDelegate.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene) // SceneDelegate의 프로퍼티에 설정해줌
        
        //이렇게 한번에 선언해줘도 되고.
        let searchVC = UINavigationController(rootViewController: SearchController()) // 맨 처음 보여줄 ViewController
        //이렇게 두줄에 걸쳐 해도 된다.
        let CommissionVC = CommissionController()
        let navigationController = UINavigationController(rootViewController: CommissionVC) // 내비게이션 컨트롤러에 처음으로 보여질 화면을 rootView로 지정해주고!

        //이것만 해놓으면 탭바는 만들어져있지만 탭바아이템이 설정되어있지않아 아무것도 출력도지 않는다.
        let tabbarController = UITabBarController()
        tabbarController.setViewControllers([navigationController, searchVC], animated: true)
        
        
        //그래서 탭바아이템 설정을 해준다.
        if let tabbarItem = tabbarController.tabBar.items {
            tabbarItem[0].image = UIImage(systemName: "dollarsign.circle")
            tabbarItem[0].selectedImage = UIImage(systemName: "dollarsign.circle.fill")
            tabbarItem[0].title = "수수료계산기"

            tabbarItem[1].image = UIImage(systemName: "person")
            tabbarItem[1].selectedImage = UIImage(systemName: "person.fill")
            tabbarItem[1].title = "유저검색"            
        }
        
        /*
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        */
        
        //시작시 보여줄 메인 컨트롤러
//        window?.rootViewController = searchVC
//        window?.makeKeyAndVisible()
        
        //그러나 탭바컨트롤러를 사용하게되면 위처럼 사용하면 안된다. 탭바컨트롤러 자체를 불러와야한다.
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        print("화면이 사라진다")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        print("화면이 나타날것")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        print("무엇에 의해 화면이 ?!")
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        print("백그라운드에서 앱으로!.")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("백그라운드 화면에 돌입한다.")
    }


}

