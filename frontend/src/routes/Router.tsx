import { createBrowserRouter, RouterProvider, BrowserRouterProps, redirect } from "react-router-dom";
import Root from "./Root";
import Feed from "./Feed";
import Reflection from "./Reflection";

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