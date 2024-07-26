import { createBrowserRouter, RouterProvider, BrowserRouterProps } from "react-router-dom";
import Root from "./Root";
import Feed from "./Feed";
import Reflection from "./Reflection";
import { LogIn } from "./LogIn";
import { LogInTokenHandling } from "./LogInTokenHandling";
import ProfileCreator from "../components/ProfileCreator";

const browserRouterProps: BrowserRouterProps = {
  basename: import.meta.env.BASE_URL
}

export const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    
    children: [
      {
        path: "feed",
        element: <Feed />
      },
      {
        path: "reflection",
        element: <Reflection />
      },
      {
        path: "profile-creator",
        element: <ProfileCreator />
      },
      {
        path: "login",
        element: <LogIn />,
        children: [
          {
            path: "token",
            element: <LogInTokenHandling />,
          }
        ]
      },
    ]
  },
],
  browserRouterProps
)

export default function Router() {
  return (
    <RouterProvider router={router} />
  )
}