import { Navbar } from "flowbite-react";

export default function TopBar() {
    return (
        <Navbar fluid rounded>
            <Navbar.Collapse>
                <Navbar.Link href="#">Home</Navbar.Link>
            </Navbar.Collapse>

        </Navbar>
    )
}