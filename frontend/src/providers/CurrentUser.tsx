import { useQuery } from "urql";
import { createContext, useEffect, useState } from "react";
import { AuthBlob, PrivateUser } from "../gql/codegen/graphql";
import { graphql } from "../gql/codegen";
import { useNavigate } from "react-router-dom";
import { createAvatar, Style } from "@dicebear/core";
import { toPng } from "@dicebear/converter";
import * as collection from "@dicebear/collection";
import { useRefreshData } from "./AuthDataStorage";
import { getAvatarImageUri } from "../components/AvatarImage";

export interface CurrentUserContextInterface {
  me: PrivateUser | undefined | null;
  avatarImageUri?: string;
  reExecuteResult: () => void;
  logout: () => void;
}

export const CurrentUserContext = createContext<CurrentUserContextInterface>({
  me: undefined,
  avatarImageUri: undefined,
  reExecuteResult: () => {},
  logout: () => {}
});



export const CurrentUserProvider = ({children}: {children: any}) => {
  const navigate = useNavigate();
  const [avatarImageUri, setAvatarImageUri] = useState<string | undefined>(undefined);
  const refreshDataContext = useRefreshData();
  const refreshData = refreshDataContext.authData;
  const setRefreshData = refreshDataContext.setAuthData;
  const shouldPause = refreshData === null;

  const [result, reExecuteResult ] = useQuery({query: graphql(`query myProfile {\n  me {\n    email\n    public {\n      avatar {\n        options\n        style\n      }\n      username\n    }\n  }\n}`),
    pause: shouldPause
   });

  const usernameIsSet = (result.data?.me?.public?.username?.length?? 0) > 0;
  const avatarIsSet = (result.data?.me?.public?.avatar?.style?.length?? 0) > 0;

  const currentUserContext: CurrentUserContextInterface = {
    me: result.data?.me,
    avatarImageUri: avatarImageUri,
    reExecuteResult,
    // TODO: lift this to Gra
    logout: () => {
      setRefreshData(null);
      localStorage.removeItem("refreshTokenJson");
      navigate("/login");
    }
  };

  useEffect(() => {
    if (shouldPause) {
      setAvatarImageUri(undefined);
    }
  }, [shouldPause])

  useEffect(() => {
    console.log("CurrentUserQueryResult: ", result);

    if (avatarIsSet) {
      getAvatarImageUri(result.data?.me.public.avatar).then((uri) => {
        setAvatarImageUri(uri);
      });
    }
    else {
      setAvatarImageUri(undefined);
    }

    if ((!usernameIsSet || !avatarIsSet) && !shouldPause && result.data?.me?.email) {
      navigate("/profile-creator");
    }

    }, [result]);

  
  return (
    <CurrentUserContext.Provider value={currentUserContext}>
      {children}
    </CurrentUserContext.Provider>
  );
};