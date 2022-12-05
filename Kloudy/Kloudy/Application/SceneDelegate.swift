//
//  SceneDelegate.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        setRootViewController(scene)
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
        
        // 갑자기 background로 가게되면 코어데이터에 저장해줌
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate {
    private func setRootViewController(_ scene: UIScene) {
        if Storage.isFirst() {
            setRootViewController(scene, viewController: OnboardingView())
        } else {
            setRootViewController(scene, viewController: ViewController())
        }
    }
    
    private func setRootViewController(_ scene: UIScene, viewController: UIViewController) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootNavigationController = UINavigationController(rootViewController: viewController)
            rootNavigationController.navigationBar.isHidden = true
            window.rootViewController = rootNavigationController
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
}
