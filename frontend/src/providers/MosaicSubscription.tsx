import { useSubscription } from "urql";
import { graphql } from "../gql/codegen";
import { useNotification } from "./Notification"



export const MosaicSubscriptionProvider = ({ children }: { children: React.ReactNode }) => {
    const {api} = useNotification();
    const subscription = graphql(`subscription newMosaicInstances {\n  mosaicInstance {\n    createdAt\n    id\n  }\n}`);
    const [useSubscriptionState, reexecuteSubscription] = useSubscription({query: subscription});

    
}