import { createBrowserRouter, RouterProvider, BrowserRouterProps } from "react-router-dom";
import Root from "./Root";
import Feed from "./Feed";
import Reflection from "./Reflection";
import { LogIn } from "./LogIn";
import { LogInTokenHandling } from "./LogInTokenHandling";
import ProfileCreator from "../components/ProfileCreator";
import { Profile } from "./Profile";
import { AuthBlob } from "../gql/codegen/graphql";
import { useState } from "react";



const browserRouterProps: BrowserRouterProps = {
  basename: import.meta.env.BASE_URL
}

export default function Router() {
  const router = createBrowserRouter([
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
        {
          path: "profile",
          element: <Profile />,
        }
      ]
    },
  ],
    browserRouterProps
  )

  return (
    <RouterProvider router={router} />
  )
}