//
//  SceneDelegate.swift
//  UIKit-Code-Based-Project
//
//  Created by SwiftMan on 2022/10/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//    guard let _ = (scene as? UIWindowScene) else { return }
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)

      window?.rootViewController = tabBarController()
      window?.makeKeyAndVisible()
  }
    
    func tabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
     
        let mainVC = MainViewController()
        let categoriesVC = CategoriesViewController()
        let cartVC = CartViewController()
        let searchVC = SearchViewController()
        let profileVC = ProfileViewController()
        
        let mainNav = UINavigationController(rootViewController: mainVC)
        let categoriesNav = UINavigationController(rootViewController: categoriesVC)
        let cartNav = UINavigationController(rootViewController: cartVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        mainNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house.fill"),
                                          selectedImage: UIImage(systemName: "house"))
        categoriesNav.tabBarItem = UITabBarItem(title: "Category",
                                               image: UIImage(systemName: "square.grid.2x2"),
                                               selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        cartNav.tabBarItem = UITabBarItem(title: "Cart",
                                         image: UIImage(systemName: "cart"),
                                         selectedImage: UIImage(systemName: "cart.fill"))
        searchNav.tabBarItem = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           selectedImage: UIImage(systemName: "magnifyingglass"))
        profileNav.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            selectedImage: UIImage(systemName: "person.fill"))
        

        tabBarController.viewControllers = [mainNav, categoriesNav, cartNav, searchNav, profileNav]
        
        return tabBarController
    }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

