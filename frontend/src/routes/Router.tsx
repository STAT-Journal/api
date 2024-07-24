import { createBrowserRouter, RouterProvider, BrowserRouterProps, redirect } from "react-router-dom";
import Root from "./Root";
import Feed from "./Feed";
import Reflection from "./Reflection";
import { LogIn } from "./LogIn";
import { login } from "../auth/AuthContext";

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
        path: "login",
        element: <LogIn />
      },
      {
        path: "token",
        action: async ({ params }) => {
          const token = params.get??("token");
          if (token) {
            // Save token to local storage
            localStorage
          }
        }
      }
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